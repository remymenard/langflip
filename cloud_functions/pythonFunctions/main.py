
from firebase_functions import https_fn, options, storage_fn
from firebase_admin import initialize_app, credentials
from firebase_admin import storage as firebase_storage
import requests
import os
import subprocess
from google.cloud import storage
import json
import requests
import base64
import shutil
import math
from datetime import datetime, timedelta
from firebase_admin import firestore
from firebase_admin.firestore import FieldFilter
from urllib.parse import urlparse, unquote

from pydub import AudioSegment
from pydub.silence import split_on_silence
from elevenlabs.client import ElevenLabs
from langchain_core.messages import HumanMessage, SystemMessage
from langchain_google_vertexai import ChatVertexAI

import platform
if platform.system() == 'Linux':
    import static_ffmpeg
    static_ffmpeg.add_paths()
elif platform.system() == 'Darwin':
    os.environ["IMAGEIO_FFMPEG_EXE"] = "/opt/homebrew/bin/ffmpeg"


from moviepy.editor import *

options.set_global_options(
    max_instances=1,
    region="europe-west4",
)

cred = credentials.Certificate("./langflip-e8589-34341ea19dd9.json")
app = initialize_app(cred)

CHUNK_SIZE = 1024

from moviepy.editor import CompositeAudioClip, AudioFileClip

db = firestore.client()
storage_client = storage.Client()


@https_fn.on_request(timeout_sec=1000, memory=options.MemoryOption.GB_4, cpu=1)
def startLipSync(req: https_fn.Request) -> https_fn.Response:
    if req.method == 'OPTIONS':
        headers = {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'POST, GET, OPTIONS, PUT, DELETE, HEAD',
            'Access-Control-Allow-Headers': 'custId, appId, Origin, Content-Type, Cookie, X-CSRF-TOKEN, Accept, Authorization, X-XSRF-TOKEN, Access-Control-Allow-Origin',
            'Access-Control-Max-Age': '3600'
        }

        return ('', 204, headers)

    # Set CORS headers for the main request
    headers = {
        'Access-Control-Allow-Origin': '*'
    }

    request_data = req.get_json()
    video_id = request_data["videoId"]
    translation_id = request_data["translationId"]
    action = request_data["action"]

    videos_ref = db.collection('videos')
    video_doc = videos_ref.document(video_id).get()

    translations_ref = db.collection('videos').document(video_id).collection('translations')
    translations_doc = translations_ref.document(translation_id).get()

    if video_doc.exists:
        video_data = video_doc.to_dict()
    else:
        return https_fn.Response(f"This video id does not exist", status=404)
    
    if translations_doc.exists:
        translations_data = translations_doc.to_dict()
    else:
        return https_fn.Response(f"Translations not found", status=404)
    
    video_url = video_data["originalVideoUrl"]
    if not video_url:
        return https_fn.Response(f"Video URL not found", status=404)
    
    captions = video_data["captions"]
    if not captions:
        return https_fn.Response(f"Captions not found", status=404)
    
    translation_language = translations_data["target_language"]
    if not translation_language:
        return https_fn.Response(f"Translation language not found", status=404)
    

    if action == "start":
        generateTranslations(video_doc, captions, translation_language)
        generateOpenVoiceAudio(video_doc, translations_doc)

        return https_fn.Response("The voices are generating.", status=200)
    elif action == "end":
        moveAudios(video_doc)
        generateFaceLocation(video_doc)
        prepare_video_for_lipsyncing(video_doc)

        return https_fn.Response("The lipsyncing process has been started", status=200)

    return https_fn.Response("No action was specified (start or end)", status=400)


def generateTranslations(video_doc, captions, translation_language):
    captions_json = json.dumps(captions)

    # Check if captions already have translated keys
    # if not any("translated" in caption for caption in captions):
    llm = ChatVertexAI(model="gemini-1.5-flash-001", max_tokens=8192, temperature=1, top_p=0.95)

    text_message = {
        "type": "text",
        "text": f""" In the following JSON, translate to {translation_language} the keys named "original" and add a new key named "translated" with the translated text. Only output the result a valid JSON, do not add any other keys and only output a valid JSON code. Never change any other key content :
        {captions_json} """,
    }

    message = HumanMessage(content=[text_message])
    response = llm.invoke([message])

    formatted_response = response.content.strip('` \n')

    if formatted_response.startswith('json'):
        formatted_response = formatted_response[4:]

    try:
        json_response = json.loads(formatted_response)
    except:
        print(f"Error converting JSON response: {formatted_response}")
        return

    video_doc.reference.update({
        'captions': json_response,
    })

    return json_response
    # else:
    #     print("Captions already have translated keys")
    #     return captions

def generateElevenLabsAudio(video_doc, json_response, language):
    client = ElevenLabs(api_key=os.environ.get("ELEVENLABS_API_KEY"))
    video_id = video_doc.id

    output_path = f"../tmp/{video_id}-vocals.wav"
    download_blob("langflip-voice-audios", f"{video_id}.wav", output_path)

    # remove all existing elevenlabs cloned voices
    voices = client.voices.get_all().voices
    for voice in voices:
        try:
            client.voices.delete(voice.voice_id)
        except Exception as e:
            print(f"Voice not found: {voice.voice_id}")

    voice = client.clone(
        name=video_id,
        description=f"A person talking in English",
        files=[output_path],
    )

    audio_files = []
    for i, caption in enumerate(json_response):
        if "translated" in caption:
            translated_text = caption["translated"]
            try:
                audio_generator = client.text_to_speech.convert(
                    text=translated_text,
                    voice_id=voice,
                    voice_settings=VoiceSettings(
                        stability=0.5, # Lower is more expressive.
                        similarity_boost=0.75,
                        style=0.2,
                    )
                )
                audio_file_path = f"/tmp/audio_{i}.mp3"

                with open(audio_file_path, "wb") as out:
                    # Iterate through the generator and write chunks to the file
                    for chunk in audio_generator:
                        out.write(chunk)
                    print(f'Audio content written to file {audio_file_path}')

                audio_files.append(audio_file_path)
            except Exception as e:
                print(f"Error generating audio for caption: {str(e)}")

    print(f"audio_files: {audio_files}")
    # Store audio files in Firebase Storage
    bucket = storage_client.bucket("langflip-voice-audios")
    audio_urls = []
    for i, audio_file in enumerate(audio_files):
        blob = bucket.blob(f"{video_doc.id}/caption_{i}.mp3")
        blob.upload_from_filename(audio_file, content_type="audio/mpeg")
        audio_urls.append(blob.public_url)

    # Update video document with audio URLs
    video_doc.reference.update({
        'audioUrls': audio_urls,
    })

def generateOpenVoiceAudio(video_doc, translation_doc):
    # video_id = video_doc.id

    video_id = video_doc.id
    translation_id = translation_doc.id
    translation_data = translation_doc.to_dict()
    voice_ref = translation_data.get('voice_id')

    if not voice_ref:
        print(f"No voice_id reference found for video {video_id}")
        return

    # Get the voice document from Firestore using the reference
    voice_doc = voice_ref.get().to_dict()

    print(f"voice_doc: {voice_doc}")

    reference_audio_url = voice_doc.get('audioUrl')
    lang = translation_data.get("target_language")

    request_data = {
            "input": {
                "firestore_video_id": video_id,
                "firestore_translation_id": translation_id,
                "reference": reference_audio_url,
                "lang": lang,
                "speed": 1.0,
            }
        }
    
    print(f"body sent to runpod: {request_data}")

    headers = {
            "Authorization": os.environ.get("RUNPOD_API_KEY"),
            "Content-Type": "application/json"
        }

    # response = requests.post(os.environ.get("RUNPOD_OPENVOICE_ENDPOINT_URL"), json=request_data, headers=headers)
    
    # Now you have the voice properties in voice_data
    # You can use these properties as needed
    # Example: accessing specific properties
    # voice_name = voice_data.get('name')
    # voice_gender = voice_data.get('gender')
    # ... and so on

    output_path = f"../tmp/{video_id}-vocals.wav"
    download_blob("langflip-voice-audios", f"{video_id}.wav", output_path)





def moveAudios(video_doc):
    video_id = video_doc.id
    video_data = video_doc.to_dict()

    # DOWNLOAD VIDEO FIRST
    video_file_name = f"{video_id}.mp4"
    video_temp_path = "../tmp/" + video_file_name

    mp4_path = f'../tmp/{video_file_name}'
    video_url = video_data["originalVideoUrl"]
    response = requests.get(video_url, stream=True)
    if response.status_code == 200:
        with open(mp4_path, 'wb') as f:
            response.raw.decode_content = True
            shutil.copyfileobj(response.raw, f)

    # Load video and mute it
    video = VideoFileClip(video_temp_path)

    audio_clips = []
    captions = video_data["captions"]
    

    bucket_name = "langflip-voice-audios"
    bucket = storage_client.bucket(bucket_name)
    for index, caption in enumerate(captions):
        # One audio_url can look like this https://storage.googleapis.com/langflip-voice-audios/ERieBsBi8tlN5RyNHJJC/caption_0.mp3
        file_name = f"caption_{index}.mp3"
        temp_path = "../tmp/" + file_name

        blob = bucket.blob(f"{video_id}/{file_name}")

        blob.download_to_filename(temp_path)
        
        audio_clip = AudioFileClip(temp_path).set_start(caption["begin"])
        audio_clips.append(audio_clip)

    # TODO : add the instrumental audio to the video
    # other_audios_bucket_name = "langflip-other-audios"
    # other_audios_bucket = storage_client.bucket(other_audios_bucket_name)

    # Parse the URL
    parsed_url = urlparse(video_url)

    # Decode the path and split it
    decoded_path = unquote(parsed_url.path)
    path_elements = decoded_path.split('/')

    path_without_file = '/'.join(path_elements[5:-1])
    name_without_extension = path_elements[8].split('.')[0]

    # instrumental_audio_blob = other_audios_bucket.blob(f"{video_id}.wav")
    # instrumental_audio_blob.download_to_filename("../tmp/instrumental.wav")

    # Load the instrumental audio file
    # instrumental_audio = AudioFileClip("../tmp/instrumental.wav")

    # Optionally, adjust the volume of the instrumental audio
    # instrumental_audio = instrumental_audio.volumex(0.5)  # Adjust volume level as needed

    # Your existing audio clips
    final_audio = CompositeAudioClip(audio_clips)

    # Combine the instrumental audio with your other audio clips
    # combined_audio = CompositeAudioClip([final_audio, instrumental_audio])
    combined_audio = CompositeAudioClip([final_audio])

    # Set the combined audio to the video
    video.audio = combined_audio

    # Export the video with the new audio
    video_output_path = "../tmp/" + video_id + "-translated.mp4"
    video.write_videofile(video_output_path, 
                          temp_audiofile='../tmp/temp-audio.m4a', 
                          codec='libx264', 
                          audio_codec='aac', 
                          bitrate='8000k', 
                          audio_bitrate='192k', 
                          preset='slow', 
                          verbose=False,
                          ffmpeg_params=["-c:a", "aac"]
                          )



    firebase_bucket = firebase_storage.bucket()

    bucket_video_file_location = f"{path_without_file}/{name_without_extension}"

    print(f"{bucket_video_file_location}-translated.mp4")
    print(video_output_path)
    # Upload the processed video back to GCS in the rendered-videos folder
    rendered_blob = firebase_bucket.blob(f"{bucket_video_file_location}-translated.mp4")
    rendered_blob.upload_from_filename(video_output_path)

    url = rendered_blob.generate_signed_url(version="v4", 
                                   expiration=timedelta(days=7), # URL valid for 7 days
                                   method='GET')

    video_doc.reference.update({
        "translatedVideoUrl": url,
        "status": "translated"
    })

    return https_fn.Response(f"The video has been translated properly", status=200)


def generateFaceLocation(video_doc):
    llm = ChatVertexAI(model="gemini-1.5-flash-001", max_tokens=8192, temperature=1, top_p=0.95)
    video_data = video_doc.to_dict()
    translated_video_url = video_data["translatedVideoUrl"]

    try:
        # Parse the Google Cloud Storage URL
        parsed_url = requests.utils.urlparse(translated_video_url)
        
        # Extract the path from the URL
        path = parsed_url.path.lstrip('/')
        
        # Split the path to get bucket name and object name
        path_parts = path.split('/', 1)
        
        if len(path_parts) != 2:
            raise ValueError("Invalid Google Cloud Storage URL format")

        bucket_name = path_parts[0]
        object_name = path_parts[1]

        # Get the bucket and blob using the existing storage_client
        # bucket = storage_client.bucket(bucket_name)
        # blob = bucket.blob(object_name)

        # Get the GCS URI
        gcs_uri = f"gs://{bucket_name}/{object_name}"

        print(f"Converted URL: {gcs_uri}")
    except Exception as e:
        print(f"Error converting URL: {str(e)}")
        return https_fn.Response(f"Error converting video URL: {str(e)}", status=500)

    media_message = {
    "type": "image_url",
    "image_url": {
        "url": gcs_uri,
        },
    }

    text_message = {
        "type": "text",
        "text": """ You are an assistant, you need to analyse videos and do 2 things. First tell when there is one person appearing in a video and looking at the camera, second tell when the elements of the videos change.

        You will have one video that you need to process and tell in a JSON format when a person is appearing in the video here is the json format to follow: {start (an integer of the seconds), end (an integer of the seconds)} """,
    }

    system_message = {
        "type": "text",
        "text": """ Analyze this video and tell me when is there someone looking straight at us.

        Guidelines :
        NEVER include in a timecode a frame that would not show a person. In case there is only 1 frame or more not showing the person you MUST stop the timecode and start a new one when a person starts to appear again.
        ONLY create a timecode if a person is clearly looking at us and speaking.
        When the elements of the video change, for example when it changes from a screen recording to a full portrait video you MUST stop the current timecode.
        Only output JSON code, the final output should be like : [ { timecode: {start (when the person start to appears): 14, end (when the person stop to appears): 19, description: 'The elements shown in this timecode with the face of the person shown (eg : a full portrait video of the person talking in front of a blue background and a plant on the foreground.).' }, ...] """
    }
    
    system_message = SystemMessage(content=[system_message])
    message = HumanMessage(content=[media_message, text_message])
    response = llm.invoke([system_message, message])

    formatted_response = response.content.strip('` \n')

    if formatted_response.startswith('json'):
        formatted_response = formatted_response[4:]

    print(formatted_response)

    try:
        json_response = json.loads(formatted_response)
    except:
        print(f"Error converting JSON response: {formatted_response}")
        return
    
    video_doc.reference.update({
        "faceLocations": json_response
    })
    

def prepare_video_for_lipsyncing(video_doc):
    video_id = video_doc.id
    video_data = video_doc.to_dict()

    face_locations = video_data.get("faceLocations")
    if not face_locations:
        print(f"No face locations found in the video {video_id}")
        return
    
    face_locations_json = json.dumps(face_locations)
    subclips = []

    original_video_path = "../tmp/" + video_id + "-translated.mp4"
    original_video = VideoFileClip(original_video_path)

    for face_location in face_locations:
        print(f"Face location: {face_location}")
        start_time = face_location.get('timecode', {}).get('start') or face_location.get('start')
        end_time = face_location.get('timecode', {}).get('end') or face_location.get('end')

        if start_time is None or end_time is None:
            print(f"Warning: Invalid time range for face location: {face_location}")
            continue

        # Add a check to verify that the end_time is not greater than the duration of the video
        if start_time > original_video.duration:
            start_time = original_video.duration

        if end_time > original_video.duration:
            end_time = original_video.duration

        subclip = original_video.subclip(start_time, end_time)
        subclips.append(subclip)

    final_clip = concatenate_videoclips(subclips)

    final_output_path = '../tmp/' + video_id + '-cut.mp4'
    final_clip.write_videofile(final_output_path, 
                               temp_audiofile='../tmp/temp-audio.m4a', 
                               codec='libx264', 
                                audio_codec='aac', 
                                bitrate='8000k', 
                                audio_bitrate='192k', 
                                preset='slow', 
                                verbose=False,
                                ffmpeg_params=["-c:a", "aac"]
                               )

    # Download the video from Cloud Storage
    video_bucket = storage_client.bucket("langflip-videos-cut")

    video_blob = video_bucket.blob(video_id + ".mp4")
    video_blob.upload_from_filename(final_output_path)

    video_doc.reference.update({
        "cuttedVideoUrl": video_blob.public_url
    })




@https_fn.on_request(timeout_sec=1000, memory=options.MemoryOption.GB_1)
def remove_silences_from_audio(req: https_fn.Request) -> https_fn.Response:

    # Parse the request body as JSON
    request_data = json.loads(req.data)

    # Get filename from the request body
    file_name = request_data.get('filename')
    if not file_name:
        return 
    
    remove_silences(file_name)

    return https_fn.Response(f"Silences removed from {file_name} and saved back to the bucket.")



# @storage_fn.on_object_finalized(bucket="langflip-voice-audios", timeout_sec=30, memory=options.MemoryOption.GB_1)
# def speechToTextFromCloudStorage(event: storage_fn.CloudEvent[storage_fn.StorageObjectData | None],) -> None:

#     file_name = event.data.name
#     file_name_without_extension = os.path.splitext(file_name)[0]

#     if file_name.__contains__("_cutted"):
#         return https_fn.Response(f"File {file_name} has already been processed", status=200)

#     if file_name.startswith("rec"):
#         file_name_without_extension = remove_silences(file_name_without_extension)

    
#     _client_options = client_options.ClientOptions(
#         api_endpoint="europe-west4-speech.googleapis.com"
#     )
#     client = SpeechClient(client_options=_client_options)

#     config_obj = cloud_speech.RecognitionConfig(
#         language_codes=["fr-FR"],
#         model="chirp"
#     )

#     print("Starting transcription")
#     print(file_name)
#     print(file_name_without_extension)

#     gcs_uri = f"gs://langflip-voice-audios/{file_name}"

#     file_metadata = cloud_speech.BatchRecognizeFileMetadata(uri=gcs_uri)

#     request = cloud_speech.BatchRecognizeRequest(
#         recognizer="projects/1089598673424/locations/europe-west4/recognizers/french",
#         config=config_obj,
#         files=[file_metadata],
#         recognition_output_config=cloud_speech.RecognitionOutputConfig(
#             gcs_output_config=cloud_speech.GcsOutputConfig(
#                 uri=f"gs://langflip-transcriptions",
#             ),
#         ),
#     )
#     client.batch_recognize(request=request)


def get_audio_duration(filename):
    print(filename)
    cmd = [
        "ffprobe",
        "-v",
        "error",
        "-show_entries",
        "format=duration",
        "-of",
        "default=noprint_wrappers=1:nokey=1",
        filename,
    ]
    output = subprocess.check_output(cmd).decode("utf-8").strip()
    # Convert the duration string to a float and return
    return float(output)


@https_fn.on_request(timeout_sec=1000, memory=options.MemoryOption.GB_4, cpu=8)
def wav2lip_postprocess(req: https_fn.Request) -> https_fn.Response:
    # Parse the request body as JSON
    request_data = req.get_json()

    print(f"request_data: {request_data}")

    # Extract the record_id and JSON data array from the request body
    record_id = request_data.get('firestore_record_id')
    translation_id = request_data.get('translation_id')


    videos_ref = db.collection('videos')

    # Assuming you have the video_id
    video_id = request_data.get('firestore_record_id')

    video_doc_ref = videos_ref.document(video_id)
    video_doc = video_doc_ref.get()  # Retrieves the document

    # Check if the document exists
    if video_doc.exists:
        video_data = video_doc.to_dict()
        # print(f"Video found: {video_data}")
        # You can now use video_data as needed in your function
    else:
        print("No video found with the specific ID")
        return https_fn.Response(f"No video found with the specific ID", status=404)

    print("Starting download of processed video")
    # Initialize Cloud Storage Client
    storage_client = storage.Client()
    wav2lip_bucket = storage_client.bucket("langflip-videos-cut")
    processed_video_blob = wav2lip_bucket.blob(f"{video_id}.mp4")
    processed_video_blob.download_to_filename('../tmp/processed-video.mp4')
    print("Video downloaded")

    original_video_url = video_data.get("translatedVideoUrl")
    original_video_path = extract_file_path_from_url(original_video_url)

    firebase_bucket = storage_client.bucket("langflip-e8589.appspot.com")
    original_video_blob = firebase_bucket.blob(original_video_path)
    original_video_blob.download_to_filename('../tmp/original-video.mp4')

    try:
        # Load the original and processed videos
        original_clip = VideoFileClip('../tmp/original-video.mp4')
        processed_clip = VideoFileClip('../tmp/processed-video.mp4').without_audio()

        # Get face locations
        face_locations = video_data.get("faceLocations")

        # Create a list to store overlay clips
        overlay_clips = []
        print("original_clip duration: ", original_clip.duration)
        print("processed_clip duration: ", processed_clip.duration)

        print(face_locations)

        for face_location in face_locations:
            start_time = face_location.get('timecode', {}).get('start') or face_location.get('start')
            end_time = face_location.get('timecode', {}).get('end') or face_location.get('end')

            if start_time is None or end_time is None:
                print(f"Warning: Invalid time range for face location: {face_location}")
                continue

            # Ensure start and end times are within the video duration
            start_time = max(0, min(start_time, processed_clip.duration))
            end_time = max(start_time, min(end_time, processed_clip.duration))

            if start_time >= end_time:
                print(f"Warning: Invalid time range (start >= end) for face location: {face_location}")
                continue

            # Create a subclip from the processed video
            processed_subclip = processed_clip.subclip(start_time, end_time)

            # Set the position and start time of the overlay clip
            overlay_clip = processed_subclip.set_start(start_time)

            overlay_clips.append(overlay_clip)

        # Create the final composite video
        final_video = CompositeVideoClip([original_clip] + overlay_clips)

        final_video_path = "../tmp/final_output_V2.mp4"

        # Output the final video
        final_video.write_videofile(final_video_path, 
                                    temp_audiofile='../tmp/temp-audio.m4a', 
                                    codec='libx264', 
                                    audio_codec='aac', 
                                    bitrate='8000k', 
                                    audio_bitrate='192k', 
                                    preset='slow', 
                                    verbose=False,
                                    ffmpeg_params=["-c:a", "aac"]
                                    )

        # Upload the final video
        lipsyncedaudio_blob = firebase_bucket.blob(original_video_path.replace("translated.mp4", "lipsynced.mp4"))
        lipsyncedaudio_blob.upload_from_filename(final_video_path)

        translations_ref = db.collection('videos').document(video_id).collection('translations').document(translation_id)


        # Update the video document with the new URL
        translations_ref.update({
            "lipsyncedVideoUrl": lipsyncedaudio_blob.public_url,
        })

        return https_fn.Response(status=200, response=f"Video {video_id} has been lipsynced and saved back to the bucket.")

    except Exception as e:
        error_message = f"An error occurred during video processing: {str(e)}"
        print(error_message)
        return https_fn.Response(status=500, response=error_message)

    finally:
        # Clean up resources
        if 'original_clip' in locals():
            original_clip.close()
        if 'processed_clip' in locals():
            processed_clip.close()

def extract_file_path_from_url(url):
    parsed_url = urlparse(url)
    # Split the path into parts
    path_parts = parsed_url.path.split('/')[1:]

    # Exclude the bucket name (the first part) and rejoin the rest
    file_path = '/'.join(path_parts[1:])

    return unquote(file_path)

def remove_silences(file_name):
    # Prepare filenames
    file_name_with_extension = file_name + ".mp3"
    file_name_cutted_without_extension = file_name + "_cutted"
    file_name_cutted = file_name + "_cutted.mp3"
    
    bucket_name = "langflip-voice-audios"
    
    # Temporary file paths
    temp_path = "../tmp/" + file_name_with_extension
    temp_path_cutted = "../tmp/" + file_name_cutted

    # Initialize the GCS storage client and get the bucket
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)

    # Check if the blob exists
    original_blob = bucket.blob(file_name_with_extension)
    if not original_blob.exists():
        return https_fn.Response(f"File {file_name_with_extension} does not exist in the bucket", status=404)

    # Download the audio file from GCS to the temporary storage of the Cloud Function instance
    original_blob.download_to_filename(temp_path)

    # Load the downloaded audio
    segment = AudioSegment.from_mp3(temp_path)

    # Use split_on_silence to remove silences
    audio_chunks = split_on_silence(
        segment,
        min_silence_len=200,
        silence_thresh=-45,
        keep_silence=50
    )

    # Combine audio chunks
    audio_processed = sum(audio_chunks, AudioSegment.empty())

    # Save the processed audio to a temporary path
    audio_processed.export(temp_path_cutted, format="mp3")
    
    # Upload the processed audio with the "_cutted" suffix to GCS
    cutted_blob = bucket.blob(file_name_cutted)  # Create a new blob with the "_cutted" suffix
    cutted_blob.upload_from_filename(temp_path_cutted)

    # Return the processed audio (though the function signature suggests it doesn't have to return anything)
    return file_name_cutted_without_extension


def download_blob(bucket_name, source_blob_name, destination_file_name):
    """Downloads a blob from the bucket."""
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(source_blob_name)

    blob.download_to_filename(destination_file_name)

def upload_blob(bucket_name, source_file_name, destination_blob_name):
    """Uploads a file to the bucket."""
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(destination_blob_name)

    blob.upload_from_filename(source_file_name)
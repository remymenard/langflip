from firebase_functions import https_fn, options
from firebase_admin import initialize_app
import os
import requests
import json
from google.cloud import translate_v2 as translate
import html
from firebase_admin import firestore
from firebase_admin.firestore import FieldFilter
from google.cloud import texttospeech
from google.cloud import storage
# from elevenlabs import Voice, VoiceSettings, generate, set_api_key
import base64
from langchain_core.messages import HumanMessage
from langchain_google_vertexai import ChatVertexAI
from urllib.parse import unquote

import os

options.set_global_options(
    max_instances=1,
    region="europe-west4",
)
app = initialize_app()

db = firestore.client()

client = texttospeech.TextToSpeechClient()
storage_client = storage.Client()

@https_fn.on_request(timeout_sec=60, memory=options.MemoryOption.MB_512, cpu=1)
def createCaptions(req: https_fn.Request) -> https_fn.Response:
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

    videos_ref = db.collection('videos')
    video_doc = videos_ref.document(video_id).get()

    if video_doc.exists:
        video_data = video_doc.to_dict()
    else:
        return https_fn.Response(f"This video id does not exist", status=404)
    
    video_url = video_data["originalVideoUrl"]

    if not video_url:
        return https_fn.Response(f"Video URL not found", status=404)
    
    try:
        # Parse the Firebase Storage URL
        parsed_url = requests.utils.urlparse(video_url)
        path = unquote(parsed_url.path)

        # Remove the initial '/v0/b/' and split the path
        path_parts = path.replace('/v0/b/', '').split('/o/', 1)
        
        if len(path_parts) != 2:
            raise ValueError("Invalid Firebase Storage URL format")

        bucket_name = path_parts[0]
        object_name = path_parts[1]

        # Get the bucket and blob using the existing storage_client
        bucket = storage_client.bucket(bucket_name)
        blob = bucket.blob(object_name)

        # Get the GCS URI
        gcs_uri = f"gs://{bucket_name}/{object_name}"

        print(f"Converted URL: {gcs_uri}")
    except Exception as e:
        print(f"Error converting URL: {str(e)}")
        return https_fn.Response(f"Error converting video URL: {str(e)}", status=500)

    
    llm = ChatVertexAI(model="gemini-1.5-flash-001", max_tokens=8192, temperature=1, top_p=0.95)
    media_message = {
    "type": "image_url",
    "image_url": {
        "url": gcs_uri,
        },
    }

    text_message = {
        "type": "text",
        "text": """ Transcribe the video audio by grouping the video audio until there is a break with nobody talking during a second or more. If you are not sure about any info, please do not make it up. Return the result in the JSON format with keys as follows : 
        { "detectedLanguage" (eg: "en-US"), tanscriptions: [ {"begin" (needs to be in integer of the number of seconds), "end" (needs to be in integer of the number of seconds), "original" (the transcription) } ] } """,
    }

    message = HumanMessage(content=[media_message, text_message])
    response = llm.invoke([message])
    print(response)

    try:
        json_response = json.loads(response.content)
    except:
        return https_fn.Response(f"Invalid JSON response: {response.content}", status=400)

    video_doc.reference.update({
        'captions': json_response.get("transcriptions", []),
        'originalLanguageCode': json_response.get("detectedLanguage", None)
    })

    return https_fn.Response(response.content, status=200, content_type="application/json")


# @https_fn.on_request(timeout_sec=60, memory=options.MemoryOption.MB_256, cpu=1)
# def generateTranslation(req: https_fn.Request) -> https_fn.Response:
#     set_api_key(os.environ.get("ELEVENLABS_API_KEY"))
#     request_data = req.get_json()

#     base_id = request_data["base_id"]
#     table_id = request_data["table_id"]
#     record_id = request_data["record_id"]
#     text = request_data["text"]

#     # Add your specific larkUrl here
#     specific_lark_url = f"https://langflip.larksuite.com/base/{base_id}"
#     print(specific_lark_url)

#     # Query Firestore for a video with the specific larkUrl
#     videos_ref = db.collection('videos')
#     # query = videos_ref.where('larkUrl', '==', specific_lark_url).limit(1)
#     query = videos_ref.where(filter=FieldFilter("larkUrl", "==", specific_lark_url)).limit(1)
#     results = query.stream()

#     video_data = None
#     for doc in results:
#         video_data = doc.to_dict()
#         break  # Assuming you only want the first match

#     # Check if a video was found
#     if video_data:
#         print(f"Video found: {video_data}")
#         # You can now use video_data as needed in your function
#     else:
#         print("No video found with the specific larkUrl")
#         return https_fn.Response(f"No video found with the specific larkUrl", status=404)
    
#     voice_provider = video_data["voiceProvider"]

#     target_language_code = video_data["targetLanguageCode"]

#     converted_code = target_language_code.split("-")[0]
#     # Google Cloud Translate
#     translate_client = translate.Client()
#     result = translate_client.translate(text, target_language=converted_code)
#     translated_text = result["translatedText"]

#     decoded_text = html.unescape(translated_text)

#     print(f"The translation is: {decoded_text}")

#     url = f"https://open.larksuite.com/open-apis/bitable/v1/apps/{base_id}/tables/{table_id}/records/{record_id}"
#     payload = json.dumps({
#         "fields": {
#             "Translation": decoded_text
#         }
#     })
#     headers = {
#         "Authorization": f"Bearer {get_lark_access_token()}"
#     }

#     lark_response = requests.request("PUT", url, data=payload, headers=headers, params={})

#     print("Lark response:")
#     print(lark_response.status_code)
#     print(lark_response.text)



#     if voice_provider == "elevenlabs":
#         # Elevenlabs
#         elevenlabs_voice_model = video_data["elevenlabsVoiceModel"]
#         audio = generate(
#             text=decoded_text,
#             voice=Voice(
#                 voice_id=elevenlabs_voice_model,
#                 settings=VoiceSettings(stability=0.71, similarity_boost=0.5, style=0.0, use_speaker_boost=True)
#             )
#         )

#          # upload to firebase storage
#         bucket_voice_audios = storage_client.bucket("langflip-voice-audios")
#         audio_file_name = f"{record_id}____{base_id}.mp3"
#         audio_file_path = f"/tmp/{audio_file_name}"

#         with open(audio_file_path, "wb") as out:
#             # Write the response to the output file.
#             out.write(audio)
#             print(f'Audio content written to file {audio_file_path}')

#         rendered_blob = bucket_voice_audios.blob(audio_file_name)
#         rendered_blob.upload_from_filename(audio_file_path)
#     else:
#         google_voice_model = video_data["googleVoiceModel"]
#         synthesis_input = texttospeech.SynthesisInput(text=decoded_text)
#         voice = texttospeech.VoiceSelectionParams(
#             language_code=target_language_code,
#             name=google_voice_model
#         )

#         audio_config = texttospeech.AudioConfig(
#             audio_encoding=texttospeech.AudioEncoding.MP3,
#             speaking_rate=1.06
#         )

#         response = client.synthesize_speech(
#             input=synthesis_input, voice=voice, audio_config=audio_config
#         )

#         # upload to firebase storage
#         bucket_voice_audios = storage_client.bucket("langflip-voice-audios")
#         audio_file_name = f"{record_id}____{base_id}.mp3"
#         audio_file_path = f"/tmp/{audio_file_name}"

#         with open(audio_file_path, "wb") as out:
#             # Write the response to the output file.
#             out.write(response.audio_content)
#             print(f'Audio content written to file {audio_file_path}')

#         rendered_blob = bucket_voice_audios.blob(audio_file_name)
#         rendered_blob.upload_from_filename(audio_file_path)

#     return https_fn.Response(f"Response from Google Translate: {translated_text}", status=200)

@https_fn.on_request(timeout_sec=1000, memory=options.MemoryOption.GB_4, cpu=8)
def saveCaptions(req: https_fn.Request) -> https_fn.Response:
    request_data = req.get_json()

    base_id = request_data["base_id"]
    table_id = request_data["table_id"]

    specific_lark_url = f"https://langflip.larksuite.com/base/{base_id}"
    videos_ref = db.collection('videos')
    # query = videos_ref.where('larkUrl', '==', specific_lark_url).limit(1)
    query = videos_ref.where(filter=FieldFilter("larkUrl", "==", specific_lark_url)).limit(1)
    results = query.stream()@https_fn.on_request(timeout_sec=60, memory=options.MemoryOption.MB_256, cpu=1)

    video_data = None
    video_doc = None
    for doc in results:
        video_doc = doc
        video_id = doc.id
        video_data = doc.to_dict()
        break  # Assuming you only want the first match

    # Check if a video was found
    if video_data:
        print(f"Video found: {video_data}")
        print(video_id)
        # You can now use video_data as needed in your function
    else:
        print("No video found with the specific larkUrl")
        return https_fn.Response(f"No video found with the specific larkUrl", status=404)
    


    url = f"https://open.larksuite.com/open-apis/bitable/v1/apps/{base_id}/tables/{table_id}/records"
    querystring = {"sort":"[\"ordered_id ASC\"]","filter":"CurrentValue.[Status]=\"Translated\""}
    payload = ""
    headers = {"Authorization": f"Bearer {get_lark_access_token()}"}

    response = requests.request("GET", url, data=payload, headers=headers, params=querystring)

    print("response got from lark")
    print(response)
    print(response.json())
    records = response.json()["data"]["items"]

    converted_json = []
    for item in records:
        fields = item.get("fields", {})
        new_item = {
            "original": fields.get("Original", [{}])[0].get("text", ""),
            "translated": fields.get("Spoken Translation", [{}])[0].get("text", ""),
            "begin": fields.get("Begin Time", 0),
            "end": fields.get("End Time", 0),
            "lark_record_id": item.get("record_id", "")
        }
        converted_json.append(new_item)

    # Convert the result to JSON string (if needed)
    converted_json_string = json.dumps(converted_json, indent=4)

    video_doc.reference.update({
        'captions': converted_json
    })


    return https_fn.Response(response=converted_json_string, status=200, content_type="application/json")


def get_lark_access_token():
    url = "https://open.larksuite.com/open-apis/auth/v3/tenant_access_token/internal"

    payload = {
        "app_id": os.environ.get("LARK_APP_ID"),
        "app_secret": os.environ.get("LARK_ACCESS_TOKEN")
    }
    headers = {
        "Content-Type": "application/json",
        "User-Agent": "insomnia/8.3.0"
    }

    response = requests.request("POST", url, json=payload, headers=headers)

    return response.json()["tenant_access_token"]
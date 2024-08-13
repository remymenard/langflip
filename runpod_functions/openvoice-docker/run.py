import runpod
import os
import time
import subprocess  # Needed to run shell commands for training
import requests
import logging
import re
import firebase_admin
from firebase_admin import credentials, storage as firebase_storage, firestore
import uuid
import urllib.parse
from google.cloud import storage
# from start_openvoice import start

logging.basicConfig(level=logging.DEBUG)

os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "./runpod-langflip-e8589-fdbf77bb6c22.json"

# Initialize Firestore DB
cred = credentials.Certificate(os.environ["GOOGLE_APPLICATION_CREDENTIALS"])

firebase_admin.initialize_app(cred, {
    'storageBucket': 'langflip-e8589.appspot.com'
})
db = firestore.client()
storage_client = storage.Client()

def download_blob(source_blob_name, destination_file_name):
    bucket = storage_client.bucket()
    blob = bucket.blob(source_blob_name)
    blob.download_to_filename(destination_file_name)
    logging.info(f"Downloaded {source_blob_name} to {destination_file_name}")

def upload_blob(source_file_name, destination_blob_name):
    bucket = storage.bucket()
    blob = bucket.blob(destination_blob_name)
    
    # Upload the file to Firebase Storage
    blob.upload_from_filename(source_file_name)

    # Generate a download token
    download_token = generate_download_token()
    
    # Set the download token in the blob's metadata
    blob.metadata = {"firebaseStorageDownloadTokens": download_token}
    blob.patch()  # Update blob metadata

    # URL-encode the blob name to ensure the URL is correct
    encoded_blob_name = urllib.parse.quote(blob.name, safe='')

    # Construct the download URL with the token
    download_url = f"https://firebasestorage.googleapis.com/v0/b/{bucket.name}/o/{encoded_blob_name}?alt=media&token={download_token}"
    
    logging.info(f"Uploaded {source_file_name} to {destination_blob_name}. Download URL: {download_url}")
    return download_url

def generate_download_token():
    return uuid.uuid4().hex

def train_voices(job):   
    job_input = job["input"]

    lang = job_input["lang"]
    reference = job_input["reference"]
    speed = job_input["speed"]

    firestore_generation_id = job_input.get("firestore_generation_id")
    firestore_translation_id = job_input.get("firestore_translation_id")
    firestore_video_id = job_input.get("firestore_video_id")

    logging.info(f"Job inputs: {job_input}")

    download_reference_location = "./reference.mp3"
    bucket_name, source_blob_name = extract_bucket_and_blob(reference)
    download_blob(source_blob_name, download_reference_location)

    if firestore_generation_id:
        firestore_voice_id = job_input["firestore_voice_id"]
        text = job_input["text"]
        command = f'python start.py --lang "{lang}" --text "{text}" --reference "{download_reference_location}" --speed {speed}'
        run_command(command)

        logging.info("OpenVoice processing completed successfully.")

        output_video_path = "./outputs_v2/output_v2.wav"
        url = upload_blob(output_video_path, f"generations/{firestore_generation_id}.wav")

        # Update Firestore record status to 'ready'
        if not firestore_generation_id or not firestore_voice_id:
            raise ValueError("Invalid or missing Firestore record ID")
        doc_ref = db.collection(f"voices/{firestore_voice_id}/generations").document(firestore_generation_id)
        doc_ref.update({"status": "ready", "url": url})

        logging.info(f"Record {firestore_generation_id} status updated to 'ready' in Firestore.")

        return url
    elif firestore_translation_id:
        translations_ref = db.collection('videos').document(firestore_video_id).collection('translations').document(firestore_translation_id)
        translations_doc = translations_ref.document(firestore_translation_id).get()

        if translations_doc.exists:
            translations_data = translations_doc.to_dict()
        else:
            print("Translation not found")
            return None
        
        videos_ref = db.collection('videos')
        video_doc = videos_ref.document(firestore_video_id).get()

        if video_doc.exists:
            video_data = video_doc.to_dict()
        else:
            print("Video not found")
            return None
        
        captions = video_data["captions"]
        
        audio_urls = []
        for i, caption in enumerate(captions):
            if "translated" in caption:
                translated_text = caption["translated"]
                try:
                    command = f'python start.py --lang "{lang}" --text "{translated_text}" --reference "{download_reference_location}" --speed {speed}'
                    run_command(command)

                    logging.info("OpenVoice processing completed successfully.")

                    output_video_path = "./outputs_v2/output_v2.wav"

                    bucket = storage_client.bucket("langflip-voice-audios")
                
                    blob = bucket.blob(f"{video_doc.id}/caption_{i}.mp3")
                    blob.upload_from_filename(output_video_path, content_type="audio/mpeg")
                    audio_urls.append(blob.public_url)

                    request_data = {
                        "videoId": firestore_video_id,
                        "translationId": firestore_translation_id,
                        "action": "end"
                    }

                    response = requests.post("https://europe-west4-langflip-e8589.cloudfunctions.net/startLipSync", json=request_data)

                    print(response)
                except Exception as e:
                    print(f"Error generating audio for caption: {str(e)}")

        translations_ref.update({"audio_urls": audio_urls})


def run_command(command):
    try:
        logging.info(f"Running command: {command}")
        current_process = subprocess.Popen(command, shell=True)

        # Wait for the command to complete and get the exit status
        exit_status = current_process.wait()

        logging.info(f"Command completed with exit status: {exit_status}")
        return exit_status
    except subprocess.CalledProcessError as e:
        logging.error(f"Error occurred: {e}")
        exit(1)

def extract_bucket_and_blob(url):
    """Extracts bucket name and source blob name from the given URL."""
    match = re.match(r'https://firebasestorage.googleapis.com/v0/b/([^/]+)/o/(.+)\?alt=media&token=', url)
    if match:
        bucket_name = match.group(1)
        source_blob_name = match.group(2).replace('%2F', '/')
        return bucket_name, source_blob_name
    else:
        raise ValueError("URL format is incorrect")

runpod.serverless.start({"handler": train_voices})
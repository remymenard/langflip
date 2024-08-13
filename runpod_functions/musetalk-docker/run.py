import runpod
from google.cloud import storage
import os
import time
import subprocess  # Needed to run shell commands for training
import requests
import yaml

os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "./runpod-langflip-e8589-fdbf77bb6c22.json"

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

def train_voices(job):   
    job_input = job["input"]
    firestore_record_id = job_input["firestore_record_id"]
    translation_id = job_input["translation_id"]

    video_path = "/home/user/input_video.mp4"
    if os.path.exists(video_path):
        os.remove(video_path)
    download_blob("langflip-videos-cut", f"{firestore_record_id}.mp4", video_path)

    # Extract audio from the video
    audio_path = "/home/user/audio.wav"
    # Remove the audio file if it already exists
    if os.path.exists(audio_path):
        os.remove(audio_path)
    run_command(f"ffmpeg -i {video_path} -vn -acodec pcm_s16le -ar 44100 -ac 2 {audio_path}")

    # Update the test.yaml file
    yaml_path = "./configs/inference/test.yaml"
    with open(yaml_path, 'r') as file:
        config = yaml.safe_load(file)

    config['task_0']['video_path'] = video_path
    config['task_0']['audio_path'] = audio_path

    with open(yaml_path, 'w') as file:
        yaml.dump(config, file)

    # Run the inference command
    run_command("python -m scripts.inference --inference_config ./configs/inference/test.yaml")
    
    output_video_path = "./results/input_video_audio.mp4"
    if not os.path.exists(output_video_path):
        print("MuseTalk ERROR no video was created")
        return False


    upload_blob("langflip-videos-cut", output_video_path, f"{firestore_record_id}.mp4")

    request_data = {
        "firestore_record_id": firestore_record_id,
        "translation_id": translation_id
    }

    response = requests.post("https://europe-west4-langflip-e8589.cloudfunctions.net/wav2lip_postprocess", json=request_data)

    print("response got from wav2lip_postprocess:")
    print(response)
    

    
def run_command(command):
    try:
        current_process = subprocess.Popen(command, shell=True)

        # Wait for the command to complete and get the exit status
        exit_status = current_process.wait()

        return exit_status
    except subprocess.CalledProcessError as e:
        print(f"Error occurred: {e}")
        exit(1)


runpod.serverless.start({"handler": train_voices})
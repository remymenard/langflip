import runpod
import spleeter
from spleeter.separator import Separator
from google.cloud import storage
import os
from moviepy.editor import VideoFileClip
import requests
import shutil
import urllib.parse
import librosa
import soundfile as sf
import numpy as np

os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "./runpod-langflip-e8589-fdbf77bb6c22.json"

# Use this function to get authenticated credentials

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

def extract_audio_from_video(video_path, audio_path):
    """Extracts audio from a video file and saves it as an MP3."""
    with VideoFileClip(video_path) as video:
        video.audio.write_audiofile(audio_path, codec='mp3')

def extract_audios(job):   
    job_input = job["input"]
    file_url = job_input["file_url"]  # The URL of the file
    record_id = job_input["record_id"]  # The ID of the record in the database
    # Decode the URL and split to extract the file name
    decoded_url = urllib.parse.unquote(file_url)
    file_name_with_extension = decoded_url.split('/')[-1].split('?')[0]

    mp4_path = f'/tmp/{file_name_with_extension}'
    file_base_name, _ = os.path.splitext(file_name_with_extension)
    mp3_path = f'/tmp/{file_base_name}.mp3'

    # Download the MP4 file from the URL
    response = requests.get(file_url, stream=True)
    if response.status_code == 200:
        with open(mp4_path, 'wb') as f:
            response.raw.decode_content = True
            shutil.copyfileobj(response.raw, f)

    # Extract audio from the MP4 file and save as MP3
    extract_audio_from_video(mp4_path, mp3_path)

    # Initialize Spleeter
    separator = Separator('spleeter:2stems')

    # Process the MP3 file and separate vocals and instruments
    separator.separate_to_file(mp3_path, '/tmp/output')

    # Upload the processed files back to Google Cloud Storage
    vocals_path = f'/tmp/output/{file_base_name}/vocals.wav'
    instruments_path = f'/tmp/output/{file_base_name}/accompaniment.wav'
    cleaned_instruments_path = f'/tmp/output/{file_base_name}/cleaned_accompaniment.wav'

    gate_audio(instruments_path, cleaned_instruments_path, threshold_dB=-20.2, attack_ms=0.1, release_ms=15.0)
    
    upload_blob('langflip-voice-audios', vocals_path, f'{record_id}.wav')
    upload_blob('langflip-other-audios', cleaned_instruments_path, f'{record_id}.wav')

    return True


def db_to_linear(db):
    return 10 ** (db / 20)

def gate_audio(input_file, output_file, threshold_dB, attack_ms, release_ms, sample_rate=22050):
    # Load the audio file
    audio, sr = librosa.load(input_file, sr=sample_rate)

    # Calculate RMS of the audio
    rms_audio = librosa.feature.rms(y=audio)[0]
    rms_max = np.max(rms_audio)

    # Convert threshold from dB to linear scale relative to the RMS
    threshold_relative = db_to_linear(threshold_dB) * rms_max

    # Convert attack and release times from ms to samples
    attack_samples = int(sample_rate * attack_ms / 1000)
    release_samples = int(sample_rate * release_ms / 1000)

    # Apply gate
    gated_audio = np.copy(audio)
    gate_open = False
    gate_opening = False
    attack_counter = 0

    for i in range(len(gated_audio)):
        current_rms = rms_audio[int(i / 512)] if int(i / 512) < len(rms_audio) else 0
        if current_rms > threshold_relative:
            if not gate_open:
                gate_opening = True
                attack_counter = attack_samples
            gate_open = True
        elif gate_open and i < len(gated_audio) - release_samples:
            # Release phase
            gated_audio[i] = audio[i] * (current_rms / threshold_relative)
            if current_rms < threshold_relative:
                gate_open = False
                gate_opening = False
        else:
            # Close the gate
            gate_open = False
            gate_opening = False
            gated_audio[i] = 0

        if gate_opening:
            # Apply linear attack
            gated_audio[i] = audio[i] * ((attack_samples - attack_counter) / attack_samples)
            attack_counter -= 1
            if attack_counter <= 0:
                gate_opening = False

    # Save the gated audio
    sf.write(output_file, gated_audio, sr)

runpod.serverless.start({"handler": extract_audios})

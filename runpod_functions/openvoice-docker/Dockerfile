# Use specific version of nvidia cuda image
FROM nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu20.04

# Remove any third-party apt sources to avoid issues with expiring keys.
RUN rm -f /etc/apt/sources.list.d/*.list

# Set shell and noninteractive environment variables
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=/bin/bash

WORKDIR /

# Update and upgrade the system packages (Worker Template)
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install --yes --no-install-recommends sudo ca-certificates git wget curl bash libgl1 libx11-6 software-properties-common ffmpeg build-essential -y &&\
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Add the deadsnakes PPA and install Python 3.10
RUN add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && \
    apt-get install python3.9-dev python3.9-venv python3-pip -y --no-install-recommends && \
    ln -s /usr/bin/python3.9 /usr/bin/python && \
    rm /usr/bin/python3 && \
    ln -s /usr/bin/python3.9 /usr/bin/python3 && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Download and install pip
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

ADD ./OpenVoice ./OpenVoice

WORKDIR /OpenVoice

RUN ["pip", "install", "-e", "."]
RUN ["pip", "install", "git+https://github.com/myshell-ai/MeloTTS.git"]
RUN ["python", "-m", "unidic", "download"]
RUN pip install --upgrade pip runpod firebase_admin google-cloud-storage

WORKDIR /

ADD ./MeloTTS ./MeloTTS
WORKDIR /MeloTTS
RUN ["pip", "install", "-e", "."]
RUN ["python", "-m", "unidic", "download"]
RUN ["python", "melo/init_downloads.py"]

# Install Python packages
# RUN --mount=type=cache,target=/root/.cache/pip

# RUN pip install torch torchvision torchaudio -f https://download.pytorch.org/whl/cu111/torch_stable.html
# RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121


WORKDIR /
# Copy the service account key file
ADD runpod-langflip-e8589-fdbf77bb6c22.json ./OpenVoice/runpod-langflip-e8589-fdbf77bb6c22.json

# Add your script file
ADD run.py ./OpenVoice/run.py
ADD test_input.json ./OpenVoice/test_input.json
ADD start.py ./OpenVoice/start.py


# WORKDIR /so-vits-svc-5.0
ADD download_files.py ./OpenVoice/download_files.py 
ADD ./faster-whisper-medium /OpenVoice/whisper
RUN wget -O /OpenVoice/whisper/model.bin https://huggingface.co/guillaumekln/faster-whisper-large-v2/resolve/main/model.bin
ADD ./se_extractor.py ./OpenVoice/openvoice/se_extractor.py
WORKDIR /OpenVoice
RUN python ./download_files.py
RUN pip install torch==1.13.0+cu117 torchvision==0.14.0+cu117 torchaudio==0.13.0 --extra-index-url https://download.pytorch.org/whl/cu117
# Call your script file when your container starts
CMD [ "python", "-u", "run.py" ]

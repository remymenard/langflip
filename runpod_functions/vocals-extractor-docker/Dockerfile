# Use specific version of nvidia cuda image
FROM nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu20.04

# Remove any third-party apt sources to avoid issues with expiring keys.
RUN rm -f /etc/apt/sources.list.d/*.list

# Set shell and noninteractive environment variables
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=/bin/bash

# Define the working directory
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
    apt-get install python3.10-dev python3.10-venv python3-pip -y --no-install-recommends && \
    ln -s /usr/bin/python3.10 /usr/bin/python && \
    rm /usr/bin/python3 && \
    ln -s /usr/bin/python3.10 /usr/bin/python3 && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Download and install pip
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

# Install Python packages
RUN --mount=type=cache,target=/root/.cache/pip
RUN pip install --upgrade pip
RUN pip install --no-binary=h5py h5py
RUN python3.10 -m pip install 'httpx<0.20.0,>=0.19.0' 'click<7.2.0,>=7.1.1' spleeter runpod google-cloud-storage moviepy numpy librosa
RUN python3.10 -m pip install --upgrade spleeter typer

# Copy the service account key file
ADD runpod-langflip-e8589-fdbf77bb6c22.json .

# Add your script file
ADD run.py .
ADD test_input.json .

# Call your script file when your container starts
CMD [ "python3.10", "-u", "/run.py" ]

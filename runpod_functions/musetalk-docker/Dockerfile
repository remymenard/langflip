FROM anchorxia/musev:latest

#MAINTAINER 维护者信息
LABEL MAINTAINER="zkangchen"
LABEL Email="zkangchen@tencent.com"
LABEL Description="musev gradio image, from docker pull anchorxia/musev:latest"

SHELL ["/bin/bash", "--login", "-c"]

# Set up a new user named "user" with user ID 1000
RUN useradd -m -u 1000 user

# Set home to the user's home directory
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH

# Set the working directory to the user's home directory
WORKDIR $HOME/app

################################################# INSTALLING FFMPEG ##################################################
# RUN apt-get update ; apt-get install -y git build-essential gcc make yasm autoconf automake cmake libtool checkinstall libmp3lame-dev pkg-config libunwind-dev zlib1g-dev libssl-dev

# RUN apt-get update \
#     && apt-get clean \
#     && apt-get install -y --no-install-recommends libc6-dev libgdiplus wget software-properties-common

#RUN RUN apt-add-repository ppa:git-core/ppa && apt-get update && apt-get install -y git

# RUN wget https://www.ffmpeg.org/releases/ffmpeg-4.0.2.tar.gz
# RUN tar -xzf ffmpeg-4.0.2.tar.gz; rm -r ffmpeg-4.0.2.tar.gz
# RUN cd ./ffmpeg-4.0.2; ./configure --enable-gpl --enable-libmp3lame --enable-decoder=mjpeg,png --enable-encoder=png --enable-openssl --enable-nonfree

# RUN cd ./ffmpeg-4.0.2; make
# RUN  cd ./ffmpeg-4.0.2; make install
######################################################################################################################

RUN echo "docker start"\ 
  && whoami \
  && which python \
  && pwd

# Install cmake and lit dependencies
RUN apt-get update && apt-get -y install cmake protobuf-compiler
RUN pip install lit


# RUN git clone -b main --recursive https://github.com/TMElyralab/MuseTalk.git
ADD ./musetalk /home/user/app/MuseTalk

# Change permissions while still root
RUN chmod -R 777 /home/user/app/MuseTalk

RUN apt-get update && apt-get install -y curl \
    && curl https://sh.rustup.rs -sSf | sh -s -- -y \
    && source $HOME/.cargo/env

# Switch to the "user" user
USER user

RUN . /opt/conda/etc/profile.d/conda.sh  \
    && echo "source activate musev" >> ~/.bashrc \
    && conda activate musev \
    && conda env list 
#    && conda install ffmpeg

RUN ffmpeg -codecs

WORKDIR /home/user/app/MuseTalk/

RUN pip install -r requirements.txt \
    && pip install --no-cache-dir -U openmim \
    && mim install mmengine \
    && mim install "mmcv>=2.0.1" \
    && mim install "mmdet>=3.1.0" \
    && mim install "mmpose>=1.1.0" 

# Add entrypoint script
#RUN chmod 777 ./entrypoint.sh
RUN ls -l  ./

EXPOSE 7860

# CMD ["/bin/bash", "-c", "python app.py"]
# CMD ["./install_ffmpeg.sh"]
RUN pip install runpod google-cloud-storage
ADD ./entrypoint.sh /home/user/app/MuseTalk/entrypoint.sh
ADD ./runpod-langflip-e8589-fdbf77bb6c22.json /home/user/app/MuseTalk/runpod-langflip-e8589-fdbf77bb6c22.json
ADD ./run.py /home/user/app/MuseTalk/run.py
ADD ./test_input.json /home/user/app/MuseTalk/test_input.json
ADD ./s3fd-619a316812.pth /home/user/.cache/torch/hub/checkpoints/s3fd-619a316812.pth
ADD ./inference.py /home/user/app/MuseTalk/scripts/inference.py
ADD ./realtime_inference.py /home/user/app/MuseTalk/scripts/realtime_inference.py
USER root
RUN chmod 777 /home/user/app/MuseTalk/entrypoint.sh
RUN conda uninstall -y ffmpeg

WORKDIR /home/
RUN wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz \
    && tar -xvf ffmpeg-release-amd64-static.tar.xz \
    && cd ffmpeg-*-amd64-static \
    && cp ffmpeg /usr/local/bin/ \
    && cp ffprobe /usr/local/bin/ \
    && cd .. \
    && rm -rf ffmpeg-*-amd64-static.tar.xz ffmpeg-*-amd64-static
WORKDIR /home/user/app/MuseTalk/

USER user
ENV FFMPEG_PATH=/usr/local/bin/ffmpeg
# RUN ffmpeg -codecs
# CMD ["ffmpeg", "-version"]
CMD ["./entrypoint.sh"]

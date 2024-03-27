FROM ubuntu:latest
RUN apt-get update && apt-get install -y \
    build-essential git vim \
    software-properties-common \
    make python3 python3-pip git \
    curl wget jq
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
      libegl1 \
      libgl1 \
      libpulse0 \
      ca-certificates \
      curl \
      jq   \
      unzip \
      coreutils \
      procps \
 && update-ca-certificates \
 && curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
      https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg \
 && echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" \
    | tee /etc/apt/sources.list.d/brave-browser-release.list \
 && apt-get update && apt-get install -y --no-install-recommends \
      brave-browser 
WORKDIR /usr/src/app

COPY requirements.txt ./
COPY myscript.py .
RUN python3 -m pip install --timeout 60 -r requirements.txt

# Create a user
RUN adduser --disabled-password --home /home/user --shell  /usr/bin/bash user

RUN  apt-get autopurge -y \
     && apt-get clean -y \
     && rm -rf /var/lib/apt/lists/*

#CMD [ "python", "./myscript.py" ]
WORKDIR /home/user
USER user

ENTRYPOINT [ "/bin/bash"]

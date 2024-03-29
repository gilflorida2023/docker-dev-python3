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
# Create a user
RUN adduser  user
WORKDIR /home/user

COPY requirements.txt ./
COPY myscript.py .
RUN python3 -m pip install --timeout 60 -r requirements.txt


RUN  apt-get autopurge -y \
     && apt-get clean -y \
     && rm -rf /var/lib/apt/lists/*


USER user
#######################################
# Get latest stable version of ublock origin. 
# had an issue with env variables, soo.
# this curl returns a  bunch of json about the project.
# grab the latest version from github apis for ublock origin
# https://docs.github.com/en/rest/pages/pages?apiVersion=2022-11-28
RUN curl -sX GET "https://api.github.com/repos/gorhill/uBlock/releases/latest"|jq -r .name|sed -e 's/^[^0-9.]*//' >/home/user/ver.txt
RUN echo "UBLOCK_ORIGIN VERSION:$(cat /home/user/ver.txt)"

# download latest version from github.
RUN wget -q --no-check-certificate -P /home/user/ "https://github.com/gorhill/uBlock/releases/download/$(cat /home/user/ver.txt)/uBlock0_$(cat /home/user/ver.txt).chromium.zip"

# unzip the extension into current directory.
RUN unzip -d /home/user/ /home/user/uBlock0_$(cat /home/user/ver.txt).chromium.zip

# rename the extension to ublock
# https://github.com/gorhill/uBlock/tree/master/dist#install
RUN mv /home/user/uBlock0.chromium /home/user/ublock

#######################################


ENTRYPOINT [ "/usr/bin/python3","/home/user/myscript.py" ]

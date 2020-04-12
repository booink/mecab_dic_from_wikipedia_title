FROM python:3.7-slim

RUN sed -i -e "s%//archive.ubuntu.com/%//jp.archive.ubuntu.com/%g" /etc/apt/sources.list

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    unlink /etc/localtime && \
    ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
ENV TZ=Etc/UTC

# set home directory
ENV HOME=/app
WORKDIR /app

# copy source file
COPY . .

# install dependencies
RUN apt-get update && apt-get install -y \
  build-essential \
  curl \
	git \
	openssl \
	sudo \
  bzip2 \
	zip \
	file \
	xz-utils \
	liblzma-dev \
  libjuman \
  libcdb-dev \
  zlib1g-dev

RUN apt-get update && apt-get install -y mecab libmecab-dev mecab-ipadic mecab-ipadic-utf8

RUN cd /usr/share/mecab && \
    git clone https://github.com/neologd/mecab-ipadic-neologd.git && \
    cd mecab-ipadic-neologd/ && \
    ./bin/install-mecab-ipadic-neologd -n -a -y -p /usr/share/mecab/dic/mecab-ipadic-neologd/

RUN pip install -r requirements.txt


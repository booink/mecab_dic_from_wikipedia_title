FROM python:3.7-slim

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
  bzip2 \
  libjuman \
  libcdb-dev \
  zlib1g-dev

RUN apt-get update && apt-get install -y mecab libmecab-dev mecab-ipadic mecab-ipadic-utf8

#RUN cd /usr/share/mecab && \
#    git clone --depth 10 https://github.com/neologd/mecab-ipadic-neologd.git && \
#    cd mecab-ipadic-neologd/ && \
#    ./bin/install-mecab-ipadic-neologd -n -a -y -p /usr/share/mecab/dic/mecab-ipadic-neologd/

RUN pip install -r requirements.txt


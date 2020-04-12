FROM python:3.7-slim

# set home directory
ENV HOME=/app
WORKDIR /app

# install dependencies
RUN apt-get update && apt-get install -y \
  build-essential \
  curl \
	git \
	openssl \
	sudo \
	zip \
	file

RUN apt-get update && apt-get install -y mecab libmecab-dev mecab-ipadic mecab-ipadic-utf8

RUN cd /usr/share/mecab && \
    git clone https://github.com/neologd/mecab-ipadic-neologd.git && \
    cd mecab-ipadic-neologd/ && \
    ./bin/install-mecab-ipadic-neologd -n -a -y -p /usr/share/mecab/dic/mecab-ipadic-neologd/

# copy source file
COPY requirements.txt ./requirements.txt

RUN pip install -r requirements.txt

# copy source file
COPY . .

RUN mkdir -p src

RUN cd src && curl -L -o jawiki-latest-all-titles-in-ns0.gz https://dumps.wikimedia.org/jawiki/latest/jawiki-latest-all-titles-in-ns0.gz && \
    gunzip jawiki-latest-all-titles-in-ns0.gz

RUN python text_regular_formatter.py
RUN python create_dic.py
RUN /usr/lib/mecab/mecab-dict-index -d /var/lib/mecab/dic/debian -u src/wikipedia.dic -f utf8 -t utf8 src/wikipedia.csv

RUN cp src/wikipedia.dic /usr/share/mecab/dic/ipadic/
RUN echo "userdic = /usr/share/mecab/dic/ipadic/wikipedia.dic" >> /etc/mecabrc


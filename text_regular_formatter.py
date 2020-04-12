#!/usr/bin/python
# -*- coding:utf-8 -*-

from unicodedata import normalize

def convert_str_to_regular_format(string):
    uni = normalize('NFKC', string).lower()
    return uni

f = open("src/jawiki-latest-all-titles-in-ns0","r")
w = open("src/jawiki-latest-all-titles-in-ns0_formatted","w")
for row in f:
    w.write(convert_str_to_regular_format(row))

f.close()
w.close()

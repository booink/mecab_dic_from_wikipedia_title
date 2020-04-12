import sys
import MeCab
import re
import subprocess
from tqdm import tqdm

# e.g. http://nemupm.hatenablog.com/entry/2014/09/26/043904

# NEologdの辞書を使って単語の存在確認をすると、「新型コロナウイルス」が「新型コロナ」「ウイルス」に分かれてしまうため、好みに合わせてどちらを使うか決める
#MECAB_IPADIC_NEOLOGD_LOCATION = " -d /usr/share/mecab/dic/mecab-ipadic-neologd/"
#mecab = MeCab.Tagger(MECAB_IPADIC_NEOLOGD_LOCATION)
mecab = MeCab.Tagger()

input_file_path = "src/jawiki-latest-all-titles-in-ns0_formatted";
output_file_path = "src/wikipedia.csv";

of = open(output_file_path, 'w')

num = subprocess.check_output(['wc', '-l', input_file_path]).decode("utf-8").lstrip().split(" ")[0]
progress = tqdm(total=int(num))

with open(input_file_path) as f:
  for line in f:
    progress.update(1)
    line = line.rstrip()

    if re.match(r'_\(.*\)$', line): # ex. "apple_(company)"
      continue
    if re.match(r'^[a-zA-Z]$', line): # one alphabet
      continue
    if re.match(r'^[0-9|!-\/:-@\[-`\{-~]*$', line): # one number or mark
      continue
    if re.match(r'^[ぁ-んァ-ヴ・ー]$', line): # one hiragana or katakana
      continue
    if re.match(r'(曖昧さの回避)', line):
      continue

    # convert underscore to space
    line = re.sub(r'^_|_$|,', '', line)
    line = re.sub(r'_', ' ', line)

    ## remove terms already existing
    n = mecab.parseToNode(line)
    n = n.next
    if n.stat == 0 and n.next.stat == 3:
      continue

    max_cost = max(-36000, -400 * len(line) ** 1.5)
    output = f"{line},0,0,{max_cost},名詞,固有名詞,*,*,*,*,{line},*,*,wikipedia,\n"

    of.write(output)

progress.close()

def max(comp, value):
  max = comp
  if comp <= value:
    max = value
  return round(max)

# WikipediaのtitleをMeCabの辞書に追加する

build

```sh
docker-compose build
```

起動

```sh
docker-compose run --rm app bash
```

mecabで形態素解析

```sh
echo "ほげほげ" | mecab
```

mecabで形態素解析(NEolodgを使用)

```sh
echo "ほげほげ" | mecab -d /usr/share/mecab/dic/mecab-ipadic-neologd/
```

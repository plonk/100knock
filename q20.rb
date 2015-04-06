=begin

20. JSONデータの読み込み

Wikipedia記事のJSONファイルを読み込み，「イギリス」に関する記事本文を表
示せよ．問題21-29では，ここで抽出した記事本文に対して実行せよ．

=end

require 'zlib'
require 'json'


def articles
  Zlib::GzipReader.open("jawiki-country.json.gz") do |gz|
    gz.each_line.map do |line|
      JSON.load(line)
    end
  end
end

article = articles.find { |e| e['title'] == 'イギリス' }
puts article['text']

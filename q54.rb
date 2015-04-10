=begin

54. 品詞タグ付け

Stanford Core NLPの解析結果XMLを読み込み，単語，レンマ，品詞をタブ区切
り形式で出力せよ．

=end

require 'nokogiri'

def main
  doc = File.open('nlp.txt.xml', &Nokogiri.method(:XML))
  doc.css('token').each do |tok|
    word = tok.css('word').first.text
    lemma = tok.css('lemma').first.text
    pos = tok.css('POS').first.text
    puts [word,lemma,pos].join("\t")
  end
end

main if __FILE__ == $0

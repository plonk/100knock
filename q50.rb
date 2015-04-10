=begin

50. 文区切り

(. or ; or : or ? or !) → 空白文字 → 英大文字というパターンを文の区切
りと見なし，入力された文書を1行1文の形式で出力せよ．

=end

File.open('nlp.txt') do |f|
  puts f.read.split(/(?<=[.;:?!])\s+(?=[A-Z])/m).map { |s| s.gsub(/\s+/, ' ') }
end

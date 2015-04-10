=begin

51. 単語の切り出し

空白を単語の区切りとみなし，50の出力を入力として受け取り，1行1単語の形
式で出力せよ．ただし，文の終端では空行を出力せよ．

=end

`ruby q50.rb`.each_line do |line|
  puts line.split
  puts
end

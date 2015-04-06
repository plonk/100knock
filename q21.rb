=begin

21. カテゴリ名を含む行を抽出

記事中でカテゴリ名を宣言している行を抽出せよ．

=end

File.open("england.txt") do |f|
  puts f.each_line.select { |line| line =~ /Category/ }
end


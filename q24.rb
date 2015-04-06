=begin

24. ファイル参照の抽出

記事から参照されているメディアファイルをすべて抜き出せ．

=end

File.open("england.txt") do |f|
  puts f.read.scan(/\[\[File:(.*?)[|\]]/).map { |filename|
    filename
  }
end



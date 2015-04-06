=begin

22. カテゴリ名の抽出

記事のカテゴリ名を（行単位ではなく名前で）抽出せよ．

=end

File.open("england.txt") do |f|
  puts f.each_line.flat_map { |line|
    if line =~ /\[\[Category:(.*?)\]\]/
      $1
    else
      []
    end
  }
end


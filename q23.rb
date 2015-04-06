=begin

23. セクション構造

記事中に含まれるセクション名とそのレベル（例えば"== セクション名 =="な
ら1）を表示せよ．

=end

File.open("england.txt") do |f|
  puts f.each_line.flat_map { |line|
    if line =~ /^=(=+)(.*?)=\1$/
      ["#{$1.size} #{$2.strip}"]
    else
      []
    end
  }
end


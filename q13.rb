=begin

13. col1.txtとcol2.txtをマージ

12で作ったcol1.txtとcol2.txtを結合し，元のファイルの1列目と2列目をタブ区切りで並べたテキストファイルを作成せよ．確認にはpasteコマンドを用いよ．

=end

ARGV << 'col1.txt' << 'col2.txt' if ARGV.empty?

puts ARGV.map { |f| open(f).read.each_line.map(&:chomp) }.transpose.map { |*fields| fields.join("\t") }

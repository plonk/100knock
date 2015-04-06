=begin

12. 1列目をcol1.txtに，2列目をcol2.txtに保存

各行の1列目だけを抜き出したものをcol1.txtに，2列目だけを抜き出したもの
をcol2.txtとしてファイルに保存せよ．確認にはcutコマンドを用いよ．

=end

def table(str)
  str.each_line.to_a.map { |line| line.chomp.split("\t") }
end

def save_lines(lines, filename)
  File.open(filename, 'w') do |f|
    f.write lines.join("\n") + "\n"
  end
end

ARGV << 'hightemp.txt' if ARGV.empty? 

tbl = table(ARGF.read)

col1 = tbl.map { |r| r[0] }
col2 = tbl.map { |r| r[1] }

save_lines(col1, 'col1.txt')
save_lines(col2, 'col2.txt')

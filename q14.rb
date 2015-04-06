=begin

14. 先頭からN行を出力

自然数Nをコマンドライン引数などの手段で受け取り，入力のうち先頭のN行だ
けを表示せよ．確認にはheadコマンドを用いよ．

=end

raise 'number' unless ARGV.size==1
n = ARGV[0].to_i

print STDIN.each_line.take(n).join

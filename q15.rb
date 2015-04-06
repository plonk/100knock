=begin

15. 末尾のN行を出力

自然数Nをコマンドライン引数などの手段で受け取り，入力のうち末尾のN行だ
けを表示せよ．確認にはtailコマンドを用いよ．

=end

raise 'number' unless ARGV.size==1
n = ARGV[0].to_i

print STDIN.each_line.to_a[-n..-1].join


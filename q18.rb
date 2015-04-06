=begin

18. 各行を3コラム目の数値の降順にソート

各行を3コラム目の数値の逆順で整列せよ（注意: 各行の内容は変更せずに並び替えよ）．確認にはsortコマンドを用いよ（この問題はコマンドで実行した時の結果と合わなくてもよい）．

※
   sort -s -n -k 3 hightemp.txt

=end

require_relative 'table'

ARGV << 'hightemp.txt' if ARGV.empty?
puts table(ARGF.read).sort_by { |r| r[2] }.map { |f| f.join("\t") }.join("\n")

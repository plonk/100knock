=begin

19. 各行の1コラム目の文字列の出現頻度を求め，出現頻度の高い順に並べる

各行の1列目の文字列の出現頻度を求め，その高い順に並べて表示せよ．確認に
はcut, uniq, sortコマンドを用いよ．

※
  cut -f 1 hightemp.txt | sort | uniq -c | sort -nr 

=end

require_relative 'table'

ARGV << 'hightemp.txt' if ARGV.empty?

tbl = table(ARGF.read)
col1 = tbl.transpose[0]

freqs = col1.group_by { |x| x }.map { |k,v| [k,v.size] }.to_h

puts freqs.sort_by { |k,v| v }.reverse.map { |k,v| "#{v} #{k}" }

=begin

17. １列目の文字列の異なり

1列目の文字列の種類（異なる文字列の集合）を求めよ．確認にはsort, uniqコ
マンドを用いよ．

=end

def table(str)
  str.each_line.to_a.map { |line| line.chomp.split("\t") }
end

ARGV << 'hightemp.txt' if ARGV.empty?

col1 = table(ARGF.read).map { |r| r[0] }

puts col1.sort.uniq

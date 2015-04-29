# 77. 正解率の計測
#
# 76の出力を受け取り，予測の正解率，正例に関する適合率，再現率，F1スコ
# アを求めるプログラムを作成せよ．

# 予測の正解率 = 当たった予想 / 全ての予想
# 適合率 = 当たった+1の予想 / 全ての+1の予想
# 再現率 = 当たった+1の予想 / 実際の+1
# F1スコア = 2 * (適合率 * 再現率)/(適合率 + 再現率)

def main
  data = File.open('q76.out', 'r') do |f|
    f.each_line.map { |l| correct_label, prediction, _ = l.chomp.split("\t"); [correct_label, prediction] }
  end

  puts "正解率 %f" % data.count { |l1, l2| l1==l2 }.fdiv(data.size)
  precision = data.count { |l1, l2| l1 == '+1' && l1 == l2 }.fdiv(data.count { |_, l2| l2 == '+1' })
  puts "適合率 %f" % precision
  recall = data.count { |l1, l2| l1 == '+1' && l1 == l2 }.fdiv(data.count { |l1, _| l1 == '+1' })
  puts "再現率 %f" % recall
  puts "F1スコア %f" % (2 * (precision*recall).fdiv(precision+recall))
end

main

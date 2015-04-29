# 78. 5分割交差検定
# 
# 76-77の実験では，学習に用いた事例を評価にも用いたため，正当な評価とは
# 言えない．すなわち，分類器が訓練事例を丸暗記する際の性能を評価してお
# り，モデルの汎化性能を測定していない．そこで，5分割交差検定により，極
# 性分類の正解率，適合率，再現率，F1スコアを求めよ．

module Enumerable
  def mean
    inject(0, :+).fdiv(size)
  end
end

def analyze(data)
  correct_percentage = data.count { |l1, l2| l1==l2 }.fdiv(data.size)
  precision          = data.count { |l1, l2| l1 == '+1' && l1 == l2 }.fdiv(data.count { |_, l2| l2 == '+1' })
  recall             = data.count { |l1, l2| l1 == '+1' && l1 == l2 }.fdiv(data.count { |l1, _| l1 == '+1' })
  f1_score           = 2*(precision*recall).fdiv(precision+recall)
  [correct_percentage, precision, recall, f1_score]
end

def print_assessment((correct_percentage, precision, recall, f1_score))
  puts "正解率 %f" % correct_percentage
  puts "適合率 %f" % precision
  puts "再現率 %f" % recall
  puts "F1スコア %f" % f1_score
end

# 与えられたファイルをk分割する
def divide(path, k)
  lines = File.read(path).each_line.to_a
  slices = lines.each_slice(lines.size / k).to_a
  if k > 0 && lines.size % k != 0
    slices[-2] = slices[-2] + slices[-1]
    slices.pop
  end

  slices.each.with_index(+1) do |slice, i|
    File.open(path + ".#{i}.test", "w") do |f|
      f.puts slice
    end
  end

  (1..k).each do |i|
    train = [*1..k] - [i]
    File.open(path + ".#{i}.train", "w") do |f|
      train.each do |j|
        f.puts slices[j-1]
      end
    end
  end
end

def cross_validate(i)
  STDERR.puts "k = #{i}"
  system("logistic_regression/logistic_regression sentiment.txt.#{i}.train > sentiment.txt.#{i}.weights")
  data = `ruby q76.rb sentiment.txt.#{i}.weights sentiment.txt.#{i}.test`.each_line.map { |l| l1, l2 = l.chomp.split("\t"); [l1, l2] }
  analyze(data)
end

def main
  divide("sentiment.txt", 5)

  result = []
  (1..5).each do |i|
    r = cross_validate(i)
    print_assessment r
    result << r
  end
  puts '平均'
  print_assessment result.transpose.map(&:mean)

  system('rm -f sentiment.txt.[1-5].*')
end

main

=begin

36. 単語の出現頻度

文章中に出現する単語とその出現頻度を求め，出現頻度の高い順に並べよ．

=end

require_relative 'q30'

def main
  itself = -> x { x }

  table = morphemes(analyzed_text)
    .reject { |morph| morph[:pos] == "記号" }
    .group_by(&itself).map { |k,v| [k, v.size] } # frequencies
    .sort_by(&:last).reverse
    .take(10)

  # 表示する

  table.each do |morph, frequency|
    printf "%d %s(%s)\n", frequency, morph[:surface], morph[:pos]
  end
end

main

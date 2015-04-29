=begin

72. 素性抽出

極性分析に有用そうな素性を各自で設計し，学習データから素性を抽出せよ．素性としては，レビューからストップワードを除去し，各単語をステミング処理したものが最低限のベースラインとなるであろう．

=end

require 'set'
require 'fast-stemmer'

require_relative 'q71'

# 全単語を書き出す
words = `cat rt-polaritydata/rt-polarity.neg.utf8 rt-polaritydata/rt-polarity.pos.utf8`.each_line.map(&:chomp).flat_map(&:split)
stems = words.reject(&method(:stop_word?)).map(&:stem).uniq.sort
puts stems


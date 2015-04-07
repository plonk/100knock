=begin

35. 名詞の連接

名詞の連接（連続して出現する名詞）を最長一致で抽出せよ．

=end

require_relative 'q30'

def main
  noun_matcher = -> m { m[:pos] == '名詞' }

  phrases = morphemes(analyzed_text)
    .chunk(&noun_matcher)
    .select { |noun_p, ms| noun_p and ms.size > 1 }
    .map    { |_, ms| ms.map(&:[].(:surface)).join(' ') }

  puts phrases
end

main

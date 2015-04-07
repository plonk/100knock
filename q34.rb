=begin

34. 「AのB」

2つの名詞が「の」で連結されている名詞句を抽出せよ．

=end

require_relative 'q30'

def main
  no_matcher = -> m { m.values_at(:surface, :pos) == ['の',  '助詞'] } 

  phrases = morphemes(analyzed_text)
    .split(no_matcher)
    .each_cons(2).map { |(*_,left), (right, *_)| [left, right] }
    .select { |left, right| left[:pos] == '名詞' and right[:pos] == '名詞' }
    .map { |left, right| "#{left[:surface]}の#{right[:surface]}" }

  puts phrases
end

main

=begin

32. 動詞の原形

動詞の原形をすべて抽出せよ．

=end

require_relative 'q30'

def main
  puts analyzed_text.flatten.select { |morph|
    morph[:pos] == '動詞'
  }.map(&:[].(:base))
end

main

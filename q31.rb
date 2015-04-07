=begin

31. 動詞

動詞の表層形をすべて抽出せよ．

=end

require_relative 'q30'

def main
  puts analyzed_text.flatten.select { |morph|
    morph[:pos] == '動詞'
  }.map(&:[].(:surface))
end

main

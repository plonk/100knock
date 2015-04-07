=begin

33. サ変名詞

サ変接続の名詞をすべて抽出せよ．

=end

require_relative 'q30'

def main
  puts analyzed_text.flatten.select { |morph|
    morph[:pos] == '名詞' and morph[:pos1] == 'サ変接続'
  }.map(&:[].(:surface))
end

main

# 71. ストップワード

# 英語のストップワードのリスト（ストップリスト）を適当に作成せよ．さら
# に，引数に与えられた単語（文字列）がストップリストに含まれている場合
# は真，それ以外は偽を返す関数を実装せよ．さらに，その関数に対するテス
# トを記述せよ．

require 'set'
require 'colorize'

STOP_WORDS = Set.new(["Mr", "Mrs", "Ms", "a", "all", "almost", "also",
                      "although", "an", "and", "any", "are", "as", "at",
                      "be", "because", "been", "both", "but", "by", "can",
                      "could", "did", "do", "does", "either", "for", 
                      "from", "had", "has", "have", "having", "he", "her",
                      "here", "hers", "him", "his", "how", "however", "i",
                      "if", "in", "into", "is", "it", "its", "just", "me",
                      "might", "my", "no", "non", "nor", "not", "of", "on",
                      "one", "only", "onto", "or", "our", "ours", "shall", 
                      "she", "should", "since", "so", "some", "still", "such",
                      "than", "that", "the", "their", "them", "then", 
                      "there", "therefore", "these", "they", "this", "those",
                      "though", "through", "thus", "to", "too", "until",
                      "very", "was", "we", "were", "what", "when", "where",
                      "whether", "which", "while", "who", "whose", "why", 
                      "will", "with", "would", "yet", "you", "your", "yours"])

def stop_word?(word)
  STOP_WORDS.include? word
end

def test
  stop_words = %w(i you me is then there since on in)
  good_words = %w(phenomenon bread letter pen egalitarian against)

  stop_words.each do |w|
    raise "#{w} should a stop word"  unless stop_word?(w)
  end

  good_words.each do |w|
    raise "#{w} should not be a stop word"  if stop_word?(w)
  end

  puts 'OK'.bold.green
rescue => e
  puts 'NG'.bold.red
  puts e.message
end

def main
  test
end

main if __FILE__ == $0

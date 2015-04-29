# 76. ラベル付け
#
# 学習データに対してロジスティック回帰モデルを適用し，正解のラベル，予
# 測されたラベル，予測確率をタブ区切り形式で出力せよ．
#!/usr/bin/env ruby
# 75. 素性の重み
#
# 73で学習したロジスティック回帰モデルの中で，重みの高い素性トップ10と，重みの低い素性トップ10を確認せよ．

require 'pp'
require_relative 'util'

class Program
  include Util

  # 特徴空間に写像する何か
  def phi(*xs)
    [*xs,1]
  end

  def load_feature_definition
    @words = []
    File.open('features.txt') do |f|
      f.each_line.map(&:chomp).each do |feat|
        @words << feat
      end
    end
  end

  require 'fast-stemmer'
  require 'set'
  # String → [0 or 1, ...]
  # 返り値の size は @words.size に等しい。
  def to_features(s)
    stems = Set.new( s.split.map(&:stem).uniq )
    @words.map { |w| stems.include?(w) ? 1 : 0 }
  end

  # インスタンス変数
  # @words 素性。ステム
  # i: 0 ~ @nsentences
  # @polarities[i] 分類
  # @sentences[i] センテンス
  # @feature_flag_set[i] 素性の束

  def load_data
    @feature_flag_set = []
    @polarities = []
    @sentences = []
    File.open(@sentiment_txt) do |f|
      f.each_line.each.with_index do |line, i|
        @polarities[i] = line[0] == '+' ? 1 : 0
        s = line[3..-2]
        @sentences << s
        @feature_flag_set << to_features(s)
      end
    end
    @nsentences = @sentences.size
  end

  def usage!
    STDERR.puts "#{$0} <SENTENCE>"
    exit 1
  end

  def main
    raise 'Usage: q76.rb [weights.txt] [sentiment.txt]' if ARGV.size > 2
    @weights_txt = ARGV[0] || 'weights.txt'
    @sentiment_txt = ARGV[1] || 'sentiment.txt'
    
    load_feature_definition
    load_data
    weights = eval File.read(@weights_txt)
    print_result(weights)
  end

  def print_result(w)
    @feature_flag_set.each.with_index do |v, i|
      prediction = sigmoid inner(w, phi(*@feature_flag_set[i]))
      positive_p = prediction >= 0.50
      puts [@polarities[i]==1 ? '+1' : '-1', positive_p ? '+1' : '-1', positive_p ? prediction : (1-prediction)].join("\t")
    end
  end
end

Program.new.main

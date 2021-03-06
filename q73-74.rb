# ロジスティック回帰
# http://gihyo.jp/dev/serial/01/machine-learning/0020

# 実行するのに 80 分かかる

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
    File.open('sentiment.txt') do |f|
      f.each_line.each.with_index do |line, i|
        @polarities[i] = line[0] == '+' ? 1 : 0
        s = line[3..-2]
        @sentences << s
        @feature_flag_set << to_features(s)
      end
    end
    @nsentences = @sentences.size
  end

  def main
    load_feature_definition
    load_data
    STDERR.puts 'data loaded'

    # ------------------------------------------
    srand
    weights = randn(@words.size + 1)
    eta = 0.1

    50.times do |i|
      STDERR.print "iteration #{i+1}"

      list = (0...@nsentences).to_a
      list.shuffle!

      list.each do |n|
        features = @feature_flag_set[n] + [1]
        prediction = sigmoid inner(weights, features)

        weights.map!.with_index do |weight, i|
          weight - eta * (prediction - @polarities[n]) * features[i]
        end
      end

      eta *= 0.9 # 学習率を減衰させる

      STDERR.puts
    end

    print_result(weights)
  end

  def print_result(w)
    @feature_flag_set.each.with_index do |v, i|
      puts "%d\t%.2f\t%s" % [@polarities[i], sigmoid(inner(w,phi(*v))), @sentences[i]]
    end
  end
end

Program.new.main

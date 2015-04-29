#!/usr/bin/env ruby
# 74. 予測
#
# 73で学習したロジスティック回帰モデルを用い，与えられた文の極性ラベル
# （正例なら"+1"，負例なら"-1"）と，その予測確率を計算するプログラムを
# 実装せよ．


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

  def usage!
    STDERR.puts "#{$0} <SENTENCE>"
    exit 1
  end

  def main
    usage! if ARGV.size != 1

    load_feature_definition
    feature_flag_set = to_features(ARGV[0])
    weights = eval File.read('weights.txt')

    prediction = sigmoid inner(weights, phi(*feature_flag_set))
    if prediction >= 0.50
      puts "+1 %d%%" % [(prediction * 100).round]
    else
      puts "-1 %d%%" % [((1 - prediction) * 100).round]
    end
  end
end

Program.new.main

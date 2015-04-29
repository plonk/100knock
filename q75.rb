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

  def usage!
    STDERR.puts "#{$0} <SENTENCE>"
    exit 1
  end

  def main
    load_feature_definition
    weights = eval File.read('weights.txt')
    
    ranking = @words.zip(weights[0..-2]).sort_by { |f, w| w }

    puts "最も重みの高い素性10"
    ranking[-10..-1].reverse.each do |f,w| 
      puts "%-20s %+f" % [f, w]
    end
    puts

    puts "最も重みの低い素性10"
    ranking[0...10].each do |f,w| 
      puts "%-20s %+f" % [f, w]
    end
  end
end

Program.new.main

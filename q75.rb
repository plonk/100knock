#!/usr/bin/env ruby
# 75. 素性の重み
#
# 73で学習したロジスティック回帰モデルの中で，重みの高い素性トップ10と，重みの低い素性トップ10を確認せよ．

require 'pp'

module Util
  # 正規分布にしたがった乱数の生成
  # http://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform
  TWO_PI = Math::PI * 2
  def generate_gaussian_noise(mu, sigma)
    $generate = !$generate
    if !$generate
      $z1 * sigma + mu
    else
      u1, u2 = loop.lazy.map { [rand, rand] }
        .drop_while { |u1, _| u1 <= Float::EPSILON }.first

      $z0 = Math.sqrt(-2.0 * Math.log(u1)) * Math.cos(TWO_PI * u2)
      $z1 = Math.sqrt(-2.0 * Math.log(u1)) * Math.sin(TWO_PI * u2)
      $z0 * sigma + mu
    end
  end
  module_function :generate_gaussian_noise

  def randn(n, *ns)
    if ns.empty?
      n.times.map { generate_gaussian_noise(0,1) }
    else
      n.times.map { randn(*ns) }
    end
  end
  module_function :randn

  # [-∞, +∞] → [0, 1]
  def sigmoid(z)
    1.0 / (1 + Math::E**-z)
  end
  module_function :sigmoid

  # 内積
  # def inner(a, b)
  #   a.zip(b).map { |ai,bi| ai*bi}.inject(:+)
  # end
  def inner(a, b)
    i = 0
    sum = 0
    ulimit = a.size
    while i < ulimit
      sum += a[i] * b[i]
      i += 1
    end
    sum
  end
  module_function :inner

end

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

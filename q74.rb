#!/usr/bin/env ruby
# 74. 予測
#
# 73で学習したロジスティック回帰モデルを用い，与えられた文の極性ラベル
# （正例なら"+1"，負例なら"-1"）と，その予測確率を計算するプログラムを
# 実装せよ．


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

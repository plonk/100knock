=begin

38. ヒストグラム

単語の出現頻度のヒストグラム（横軸に出現頻度，縦軸に出現頻度をとる単語
の種類数を棒グラフで表したもの）を描け．


=end

require_relative 'q30'

module Enumerable
  def with_intermission(intermission, &block)
    if block
      with_index do |elt, i|
        intermission.() unless i==0
        yield(elt)
      end
    else
      Enumerator.new do |yielder|
        with_index do |elt, i|
          intermission.() unless i==0
          yield(elt)
        end
      end
    end
  end

  def frequencies
    itself = -> x { x }
    group_by(&itself).map { |k,v| [k, v.size] }
  end
end

GRANULARITY = 1000

def freq_to_range(freq)
  bottom = freq / GRANULARITY * GRANULARITY
  bottom..(bottom+GRANULARITY-1)
end

require 'gnuplot'

include Gnuplot

def plot_histogram(histogram)
  Gnuplot.open do |gp|
    Plot.new(gp) do |p|
      p.style 'fill solid border linecolor rgb "black"'
      p.xtics 'nomirror rotate by -45'

      p.data << DataSet.new(histogram) do |d|
        d.using = "0:2:xtic(1)"
        d.with = 'boxes linecolor rgb "light-green"'
        d.notitle
      end
    end
  end
end

def histogram_base(ulimit)
  bottoms = (0...Float::INFINITY).lazy
    .map { |i| i * GRANULARITY }
    .take_while { |x| x <= ulimit }

  bottoms.map { |b| [b..(b+GRANULARITY-1), 0] }.to_h
end

def main
  freq_table = morphemes(analyzed_text)
    .reject { |m| m[:pos] == '記号' }
    .map { |occur| to_type(occur) }
    .frequencies

  base = histogram_base(freq_table.transpose[1].max)

  histogram = freq_table
    .map { |morph, freq| [morph, freq_to_range(freq)] }
    .transpose[1]
    .frequencies

  histogram = base.merge(histogram.to_h)
    .map { |r, f| ["#{r.begin}~#{r.end}", f] }

  plot_histogram(histogram.transpose)
end

main

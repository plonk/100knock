=begin

39. Zipfの法則

単語の出現頻度順位を横軸，その出現頻度を縦軸として，両対数グラフをプロットせよ．

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

require 'gnuplot'

include Gnuplot

def plot_graph(table)
  Gnuplot.open do |gp|
    Plot.new(gp) do |p|
      p.logscale 'x'
      p.logscale 'y'
      p.xrange '[1:]'
      p.xlabel '出現頻度順位'
      p.ylabel '出現頻度'
      p.style 'fill solid'

      p.data << DataSet.new(table) do |d|
        d.using = "2:1"
        d.with = 'boxes linecolor rgb "dark-green"'
        d.notitle
      end
    end
  end
end

def main
  # [[morpheme, frqeuency], ...]
  freq_table = morphemes(analyzed_text)
    .reject { |m| m[:pos] == '記号' }
    .map { |occur| to_type(occur) } # 表層形を無視する。
    .frequencies
  
  freqs = freq_table.transpose[1].uniq.sort.reverse
  plot_graph( freqs.each.with_index(1).to_a.transpose )
end

main

=begin

37. 頻度上位10語

出現頻度が高い10語とその出現頻度をグラフ（例えば棒グラフなど）で表示せよ．

=end

require 'stringio'

require 'unicode'
require 'colorize'

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

end


class BarChart
  def initialize(width = 40)
    @table = []
    @width = width
  end

  def add(label, number)
    @table << [label, number]
  end

  def render
    max = @table.map(&:last).max

    buf = StringIO.new
    @table.each.with_intermission -> { buf.puts } do |label, number|
      buf.printf "%s %s %s\n", justify(label, 10), bar(number.to_f/max).blue, comma_separate(number)
    end
    buf.rewind
    buf.read
  end

  def comma_separate(integer)
    integer.to_s.reverse.scan(/.{1,3}/).join(',').reverse
  end

  def justify(str, width, align: :right)
    shortage = width - Unicode::width(str, true)
    pad = ' ' * [shortage, 0].max
    case align
    when :right
      "#{pad}#{str}"
    when :left
      "#{str}#{pad}"
    else
      raise
    end
  end

  private

  def bar(fraction)
    # 0/8 から 8/8 まで。
    segments = %w(\  ▏ ▎ ▍ ▌ ▋ ▊ ▉ █)

    eighths = (fraction * @width * 8).round
    segments[8] * (eighths / 8) + segments[(eighths % 8)]
  end

end

def main
  itself = -> x { x }

  table = morphemes(analyzed_text)
    .reject { |m| m[:pos] == '記号' }
    .map { |m| to_type(m) }
    .group_by(&itself).map { |k,v| [k, v.size] } # frequencies
    .sort_by(&:last).reverse
    .take(10)

  # 表を作る。
  chart = BarChart.new
  max = table.first[1]
  table.each do |morph, frequency|
    chart.add(morph[:base], frequency)
  end

  # 表示する
  1.times { puts }
  puts '出 現 頻 度 ト ッ プ 1 0'
  puts
  puts chart.render
  1.times { puts }
end

main


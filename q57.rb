=begin

57. 係り受け解析

Stanford Core NLPの係り受け解析の結果（collapsed-dependencies）を有向グ
ラフとして可視化せよ．可視化には，係り受け木をDOT言語に変換し，
Graphvizを用いるとよい．また，Pythonから有向グラフを直接的に可視化する
には，pydotを使うとよい．

=end

require 'nokogiri'
require 'graphviz'

class Edge < Struct.new(:from, :to, :type)
  def self.[](*args)
    Edge.new(*args)
  end
end

# deps: [[[String,String], [String,String]]*]
def output(edges, filename)
  g = GraphViz.new(:G, type: :digraph)

  nodes = {}
  edges.flat_map { |e| [e.from, e.to] }.uniq.each do |idx, label|
    nodes[idx] = g.add_nodes(idx, label: label)
  end

  edges.each do |e|
    gov_idx, = e.from
    dep_idx, = e.to
    g.add_edges(nodes[gov_idx], nodes[dep_idx], label: e.type)
  end

  g.output(png: filename)
end

def to_graphs(doc)
  doc.css('document > sentences > sentence').map do |sentence|
    sentence.css('dependencies[type=collapsed-dependencies] > dep').map do |dep|
      gov = dep.css('governor').first
      dependent = dep.css('dependent').first
      type = dep['type']

      Edge[[gov['idx'], gov.text], [dependent['idx'], dependent.text], ' '+type]
    end
  end
end

def main
  doc = File.open('nlp.txt.xml', &Nokogiri.method(:XML))

  graphs = to_graphs(doc)

  Dir.mkdir 'q57' unless File.directory? 'q57'
  graphs.each.with_index(1) do |edges, i|
    puts "q57/sentence#{i}.png"
    output(edges, "q57/sentence#{i}.png")
  end
end

main if __FILE__ == $0


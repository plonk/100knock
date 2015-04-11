=begin

57. 係り受け解析

Stanford Core NLPの係り受け解析の結果（collapsed-dependencies）を有向グ
ラフとして可視化せよ．可視化には，係り受け木をDOT言語に変換し，
Graphvizを用いるとよい．また，Pythonから有向グラフを直接的に可視化する
には，pydotを使うとよい．

=end

require 'nokogiri'
require 'graphviz'

# deps: [[[String,String], [String,String]]*]
def output(deps, filename)
  g = GraphViz.new(:G, type: :digraph)

  nodes = {}
  deps.flatten(1).uniq.each do |idx, label|
    nodes[idx] = g.add_nodes(idx, label: label)
  end

  deps.each do |(gov_idx, gov_label), (dep_idx, dep_label)|
    g.add_edges(nodes[gov_idx], nodes[dep_idx])
  end

  g.output(png: filename)
end

def main
  doc = File.open('nlp.txt.xml', &Nokogiri.method(:XML))

  Dir.mkdir 'q57' unless File.directory? 'q57'
  deps = doc.css('document > sentences > sentence').each do |sentence|
    deps = sentence.css('dependencies[type=collapsed-dependencies] > dep').map do |dep|
      gov = dep.css('governor').first
      dependent = dep.css('dependent').first

      [[gov['idx'], gov.text], [dependent['idx'], dependent.text]]
    end

    puts "q57/sentence#{sentence['id']}.png"
    output(deps, "q57/sentence#{sentence['id']}.png")
  end

end

main if __FILE__ == $0


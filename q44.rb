=begin

44. 係り受け木の可視化

与えられた文の係り受け木を有向グラフとして可視化せよ．可視化には，係り
受け木をDOT言語に変換し，Graphvizを用いるとよい．また，Pythonから有向グ
ラフを直接的に可視化するには，pydotを使うとよい．

=end

require 'readline'
require 'graphviz'
require_relative 'q41'

def output(edges, filename)
  g = GraphViz.new(:G, type: :digraph)

  nodes = edges.flatten
    .map(&:unpunctuated_text)
    .uniq
    .map { |label| [label, g.add_nodes(label)] }
    .to_h

  edges.each do |c1, c2|
    src = nodes[c1.unpunctuated_text]
    dst = nodes[c2.unpunctuated_text]
    g.add_edges(src, dst)
  end
  g.output(png: filename)
end

def main
  tempfile = Tempfile.new($0)
  while line = Readline.readline("文？ ", true)
    cs, = parse(line)
    output(pair_up(cs), tempfile.path)
    system('xdg-open', tempfile.path)
  end
rescue
  Tempfile.close
end

main

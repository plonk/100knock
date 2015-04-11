=begin

58. タプルの抽出

Stanford Core NLPの係り受け解析の結果（collapsed-dependencies）に基づき，
「主語 述語 目的語」の組をタブ区切り形式で出力せよ．ただし，主語，述語，
目的語の定義は以下を参考にせよ．

    述語: nsubj関係とdobj関係の子（dependant）を持つ単語
    主語: 述語からnsubj関係にある子（dependent）
    目的語: 述語からdobj関係にある子（dependent）

=end

require_relative 'q57'

# 文を表わすグラフから「主語-動詞-直接目的語」の例を抽出する。
def svo_instances(edges)
  object = {}
  subject = {}

  edges.each do |edge|
    case edge.type
    when 'nsubj'
      subject[edge.from] = edge.to
    when 'dobj'
      object[edge.from]  = edge.to
    end
  end

  # 主語と目的語が揃っている場合のみを対象とする。
  verbs = (subject.keys & object.keys)
  verbs.map do |v|
    _idx, text = v
    [subject[v][1], text, object[v][1]]
  end
end

def output(table)
  table.each do |row|
    puts row.join("\t")
  end
end

def main
  doc = File.open('nlp.txt.xml', &Nokogiri.method(:XML))
  gs = to_graphs(doc)

  table = gs.flat_map { |g| svo_instances(g) }
  output table
end

main if __FILE__ == $0

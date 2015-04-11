=begin

59. S式の解析

Stanford Core NLPの句構造解析の結果（S式）を読み込み，文中のすべての名
詞句（NP）を表示せよ．入れ子になっている名詞句もすべて表示すること．

=end

require 'nokogiri'
require 'pp'

def parse_sexp(sexp)
  code = sexp.gsub(/\(|\)|[^\)\s]+|\s+/) { |tok|
    case tok
    when '(' then '['
    when ')' then '],'
    when /\A\s+\z/ then ''
    else
      ":#{tok.inspect},"
    end
  }
  eval(code.strip[0..-2])
end

def extract_nps(sexp)
  np_p = -> s { s[0]==:NP }
  atom_p = -> s { s.is_a? Symbol }

  case sexp
  when atom_p
    []
  when []
    []
  when np_p
    [sexp] + sexp.flat_map { |child| extract_nps(child) }
  else
    sexp.flat_map { |child| extract_nps(child) }
  end
end

def render_phrase(phrase)
  _label, *body = phrase
  body.map { |node|
    if node.is_a? Array
      render_phrase(node)
    else
      node.to_s
    end
  }.join(' ')
end

def main
  doc = File.open('nlp.txt.xml', &Nokogiri.method(:XML))

  sexps = doc.css('parse').map do |p|
    parse_sexp(p.text)
  end

  nps = sexps.flat_map { |s| extract_nps(s) }
  nps.each do |np|
    puts render_phrase(np)
  end
end

main if __FILE__ == $0

=begin

47. 機能動詞構文のマイニング

頻出述語
    $ cat q47.txt | cut -f 1 | sort | uniq -c | sort -nr | head
         29 返事をする
         21 挨拶をする
         14 話をする
         14 真似をする
         11 喧嘩をする
          8 質問をする
          7 運動をする
          6 話を聞く
          6 昼寝をする
          5 問答をする

頻出述語パターン
    $ cat q47.txt | cut -f1,2 | egrep -v '\s$' | sort | uniq -c | sort -nr | head
          6 返事をする      と
          4 返事をする      と は
          4 挨拶をする      と
          3 質問をかける    と は
          3 喧嘩をする      と
          3 挨拶をする      から
          2 同情を表する    て と は
          2 講義をする      で
          2 休養を要する    は
          2 覚悟をする      と

=end

require_relative 'q41'

def print_row(triple)
  verbal_phrase, particles, chunks = triple
  pstr = particles.join(' ')
  cstr = chunks.join(' ')
  puts [verbal_phrase, pstr, cstr].join("\t")
end

class Hash
  def ===(obj)
    all? do |k,v|
      v === obj.send(k)
    end
  end

end

def main
  doc = load_document

  triples = doc.lazy.flat_map { |cs|
    pair_up(cs).select { |c1, c2|
      left = c1.morphs
      right = c2.morphs

      (left.size==2 &&
       { pos: '名詞', pos1: 'サ変接続' } === left[0] &&
       { pos: '助詞', base: 'を' } === left[1]) &&
      (right.any? { |m| m.pos == '動詞' })
    }.map { |c1, c2|
      p [c2.id, c2.dst, c2.srcs]
      deps = cs.values_at(*c2.srcs).select { |c| c.morphs.any? { |m| m.pos=='助詞' } && c!=c1}
        .sort_by { |c| c.morphs.reverse.find { |m| m.pos=='助詞' }.base }
      particles = deps.map { |c| c.morphs.reverse.find { |m| m.pos=='助詞' } }.map(&:base)
      phrases = deps.map { |c| c.unpunctuated_text }
      ["#{c1.unpunctuated_text}#{c2.morphs.find { |m| m.pos=='動詞' }.base}", particles, phrases]
    }
  }.each(&method(:print_row))
end

main

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

class Hash
  def to_pred
    -> obj { all? { |k,v| v === obj.send(k) } }
  end
end

alias edges pair_up

def time(label)
  b = Time.now
  yield.tap do
    STDERR.puts "#{label}: #{((Time.now - b)*1000).round} milliseconds"
  end
end

# --------------------------------------------------------------------

def render_row(verbal_phrase, particles, chunks)
  [verbal_phrase, particles.join(' '), chunks.join(' ')].join("\t")
end

Verbal_noun_p = { pos: '名詞', pos1: 'サ変接続' }.to_pred
Particle_wo_p = { pos: '助詞', base: 'を' }.to_pred
Particle_p = proc { |m| m.pos == '助詞' }
Verb_p = proc { |m| m.pos == '動詞' }

# [Chunk, Chunk] -> Bool
def light_verb_construction?(c1, c2)
  return false unless c1.morphs.size==2

  fst, snd = c1.morphs
  return Verbal_noun_p.(fst) && Particle_wo_p.(snd) && c2.morphs.any?(&Verb_p)
end

# [Morph*] → Morph or nil
def last_particle(morphs)
  morphs.reverse_each.find(&Particle_p)
end

# [Chunk,Chunk] → [[String, [String*], [String*]]*]
def to_row((c1, c2), environ)
  deps = environ.values_at(*c2.srcs).reject { |c| c==c1 }
    .select { |c| c.morphs.any?(&Particle_p) }

  dep_particles, dep_phrases = deps.map { |c| [last_particle(c.morphs).base, c.unpunctuated_text] }
    .sort_by(&:first).transpose

  lv_construction = "#{c1.unpunctuated_text}#{c2.morphs.find(&Verb_p).base}"
  dep_particles ||= []
  dep_phrases ||= []

  [lv_construction, dep_particles, dep_phrases]
end

#             動詞構文, 係る助詞,  係る文節
# [Chunk*] → [[String, [String*], [String*]]*]
def light_verb_constructions(sentence)
  edges(sentence)
    .select { |c1,c2| light_verb_construction?(c1, c2) }
    .map { |chunks| to_row(chunks, sentence) }
end

def main
  doc = time("load document") { load_document }

  doc.flat_map { |sent|
    light_verb_constructions(sent)
  }.each do |row|
    puts render_row(*row)
  end
end

main

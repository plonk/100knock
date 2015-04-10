=begin

46. 動詞の格フレーム情報の抽出

=end

require_relative 'q41'

def tabulate(list)
  list.each do |verb, occurrences|
    particles, chunks = occurrences.transpose
    pstr = particles.map(&:base).join(' ')
    cstr = chunks.join(' ')
    puts [verb.base, pstr, cstr].join("\t")
  end
end

def main
  load_document.each do |cs|
    verb_particle_pairs = pair_up(cs).flat_map { |c1, c2|
      particle = c1.morphs.find { |m| m.pos=='助詞' }
      verb = c2.morphs.find { |m| m.pos=='動詞' } # 最左の動詞を選択する

      # 1 文に同じ動詞が2回使われていた場合、パターンが混ざらないように
      # Morph 全体をキーにする
      particle && verb ? [ [verb, [particle, c1.unpunctuated_text]] ] : []
    }
    
    # 1文分を出力する
    tabulate to_multi_hash(verb_particle_pairs)
  end

end

main

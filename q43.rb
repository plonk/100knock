=begin

43. 名詞を含む文節が動詞を含む文節に係るものを抽出

名詞を含む文節が，動詞を含む文節に係るとき，これらをタブ区切り形式で抽
出せよ．ただし，句読点などの記号は出力しないようにせよ．

=end

require_relative 'q41'

def main
  matches = load_document.flat_map { |chunks|
    pair_up(chunks).select { |c1, c2|
      c1.morphs.any? { |m| m.pos == '名詞' } && c2.morphs.any? { |m| m.pos == '動詞' }
    }
  }

  matches.each do |c1, c2|
    puts "#{c1.unpunctuated_text}\t#{c2.unpunctuated_text}"
  end
end

main

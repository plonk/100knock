=begin

43. 名詞を含む文節が動詞を含む文節に係るものを抽出

名詞を含む文節が，動詞を含む文節に係るとき，これらをタブ区切り形式で抽
出せよ．ただし，句読点などの記号は出力しないようにせよ．

=end

require_relative 'q41'

def tabulate(chunks)
  chunks.each do |c|
    if c.dst == -1
      puts c.unpunctuated_text
    else
      puts "#{c.unpunctuated_text}\t#{chunks[c.dst].unpunctuated_text}"
    end
  end
end

def main
  load_document.each do |sentence|
    tabulate(sentence)
  end
end

main

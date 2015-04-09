=begin

42. 係り元と係り先の文節の表示

係り元の文節と係り先の文節のテキストをタブ区切り形式ですべて抽出せよ．
ただし，句読点などの記号は出力しないようにせよ．

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

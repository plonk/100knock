=begin

55. 固有表現抽出

入力文中の人名をすべて抜き出せ．

=end

require 'nokogiri'

def main
  doc = File.open('nlp.txt.xml', &Nokogiri.method(:XML))
  doc.css('token').select { |tok|
    tok.css('POS').first.text =~ /\ANNPS?\z/ && tok.css('NER').first.text == 'PERSON'
  }.each do |tok|
    puts tok.css('word').first.text
  end
end

main if __FILE__ == $0


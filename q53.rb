=begin

53. Tokenization

=end

require 'nokogiri'

def main
  doc = File.open('nlp.txt.xml', &Nokogiri.method(:XML))
  doc.css('token').each do |tok|
    word = tok.css('word').first
    puts word.text
  end
end

main if __FILE__ == $0

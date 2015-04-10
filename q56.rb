=begin

56. 共参照解析

Stanford Core NLPの共参照解析の結果に基づき，文中の参照表現（mention）
を代表参照表現（representative mention）に置換せよ．ただし，置換すると
きは，「代表参照表現（参照表現）」のように，元の参照表現が分かるように
配慮せよ．

=end

require 'nokogiri'

def main
  doc = File.open('nlp.txt.xml', &Nokogiri.method(:XML))
  corefs = doc.css('document > coreference').first
  corefs.css('coreference').each do |coref|
    mr = coref.css('mention[representative=true]').first
    others = coref.css('mention:not([representative=true])').map { |m| m.css('text').first.text }
    
    puts "#{mr.css('text').text} (#{others.join('|')})"
  end
end

main if __FILE__ == $0


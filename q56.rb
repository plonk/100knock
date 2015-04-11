=begin

56. 共参照解析

Stanford Core NLPの共参照解析の結果に基づき，文中の参照表現（mention）
を代表参照表現（representative mention）に置換せよ．ただし，置換すると
きは，「代表参照表現（参照表現）」のように，元の参照表現が分かるように
配慮せよ．

=end

require 'nokogiri'

class Mention
  def self.from_elt(elt)
    Mention.new.tap do |m|
      m.representative = elt['representative']=='true'
      m.sentence = elt.css('sentence').first.text.to_i
      m.start    = elt.css('start').first.text.to_i
      m.end      = elt.css('end').first.text.to_i
      m.head     = elt.css('head').first.text.to_i
      m.text     = elt.css('text').first.text
    end
  end

  # 文字位置の半開区間に変換する。
  def to_offsets(doc)
    offset_begin = doc.css("sentence##{sentence} > tokens > token##{start}").css('CharacterOffsetBegin').first.text.to_i
    offset_end   = doc.css("sentence##{sentence} > tokens > token##{self.end-1}").css('CharacterOffsetEnd').first.text.to_i
    [offset_begin, offset_end]
  end

  attr_accessor :representative, :sentence, :start, :end, :head, :text
end

class Coreference
  def self.from_elt(elt)
    Coreference.new.tap do |c|
      c.mentions = elt.css('mention').map { |mention| Mention.from_elt(mention) }
    end
  end

  attr_accessor :mentions
end

class Program
  attr_accessor :doc

  def replace(text, corefs)
    plan = corefs.flat_map do |coref|
      rep = coref.mentions.find(&:representative)
      plan = coref.mentions.reject(&:representative).map do |mention|
        a, b = mention.to_offsets(doc)
        [a, b, "【#{rep.text} 《#{mention.text}》】"]
      end
    end.sort_by(&:first).reverse
 
    plan.each do |a, b, alt_text|
      text[a ... b] = alt_text
    end
    text
  end

  def main
    self.doc = File.open('nlp.txt.xml', &Nokogiri.method(:XML))
    corefs = doc.css('document > coreference').first
      .css('coreference').map { |coref| Coreference.from_elt(coref) }
    text = File.open('nlp.txt') do |f|
      f.read
    end
    print replace(text, corefs)
  end
end

Program.new.main if __FILE__ == $0


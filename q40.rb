=begin

40. 係り受け解析結果の読み込み（形態素）

形態素を表すクラスMorphを実装せよ．このクラスは表層形（surface），基本
形（base），品詞（pos），品詞細分類1（pos1）をメンバ変数に持つこととす
る．さらに，CaboChaの解析結果（neko.txt.cabocha）を読み込み，各文を
Morphオブジェクトのリストとして表現し，3文目の形態素列を表示せよ．

=end

require 'nokogiri'
require 'pp'

class Hash
  alias + merge
end

# 形態素(とその表層形)を表わすクラス
class Morph < Struct.new(:surface, :pos, :pos1, :base)
  def self.from_hash(hash)
    hash.each.with_object(Morph.new) do |(key, val), m|
      m.send("#{key}=", val)
    end
  end
end

def parse_feature(feature_string)
  pos, pos1, _, _, _, _, base, _, _ = feature_string.split(',')
  { pos: pos, pos1: pos1, base: base }
end

def load_document
  xml = "<root>"
  xml.concat  File.open("neko.txt.cabocha", &:read)
  xml.concat "</root>"

  doc = Nokogiri::XML(xml)
  doc.css('root > sentence').map { |sentence|
    sentence.css('tok').map { |tok|
      Morph.from_hash({ surface: tok.text } + parse_feature( tok['feature'] ))
    }
  }
end

def main
  pp load_document[2]
end

main

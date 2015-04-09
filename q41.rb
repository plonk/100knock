=begin

41. 係り受け解析結果の読み込み（文節・係り受け）

40に加えて，文節を表すクラスChunkを実装せよ．このクラスは形態素（Morph
オブジェクト）のリスト（morphs），係り先文節インデックス番号（dst），係
り元文節インデックス番号のリスト（srcs）をメンバ変数に持つこととする．
さらに，入力テキストのCaboChaの解析結果を読み込み，１文をChunkオブジェ
クトのリストとして表現し，8文目の文節の文字列と係り先を表示せよ．第5章
の残りの問題では，ここで作ったプログラムを活用せよ．

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

class Chunk
  attr_reader :morphs
  attr_accessor :dst, :srcs
  attr_reader :id

  def initialize(id, morphemes)
    @id = id
    @morphs = morphemes
    @dst = nil
    @srcs = []
  end

  def form_link_to(other_id)
    @dst = other_id
    other.srcs << self.id
  end

  def text
    morphs.map(&:surface).join
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
    chunks = sentence.css('chunk').map { |chunk|
      morphemes = chunk.css('tok').map { |tok|
        Morph.from_hash({ surface: tok.text } + parse_feature( tok['feature'] ))
      }
      Chunk.new(chunk['id'].to_i, morphemes)
    }

    # 係り受け関係を設定する。
    sentence.css('chunk').zip(chunks).each do |elt, chunk|
      dst_idx = elt['link'].to_i
      chunk.dst = dst_idx
      chunks[dst_idx].srcs << chunk.id
    end
    chunks
  }
end

def main
  sentence = load_document[7]
  sentence.each do |chunk|
    puts "(#{chunk.id}) #{chunk.text}"
    dst = sentence[chunk.dst]
    puts "\t→ (#{dst.id}) #{dst.text}" unless chunk.dst == -1
    puts
  end
end

main if __FILE__ == $0

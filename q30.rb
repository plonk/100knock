=begin

30. 形態素解析結果の読み込み

形態素解析結果（neko.txt.mecab）を読み込むプログラムを実装せよ．ただし，
各形態素は表層形（surface），基本形（base），品詞（pos），品詞細分類
1（pos1）をキーとするマッピング型に格納し，1文を形態素（マッピング型）
のリストとして表現せよ．第4章の残りの問題では，ここで作ったプログラムを
活用せよ．

  
=end

module Enumerable
  def split(pattern)
    Enumerator.new do |yielder|
      chunk = []
      self.each do |elt|
        if pattern === elt
          yielder << chunk
          chunk = []
        else
          chunk << elt
        end
      end
      yielder << chunk unless chunk.empty?
    end.tap do |enumerator|
      enumerator.each do |chunk|
        yield(chunk)
      end if block_given?
    end
  end

end

module Enumerable
  def intersperse(pad)
    flat_map { |elt| [pad,elt] } . drop(1)
  end

  def proc_map(&block)
    if block
      map { |elt| -> { block.call(elt) } }
    else
      Enumerator.new do |yielder|
        each do |elt|
          yielder << -> { block.call(elt) }
        end
      end
    end

  end

end

class Proc
  def +(other)
    -> { self.(); other.() }
  end

end 

class Symbol
  def call(*args, &block)
    -> obj { obj.send(self, *args, &block) }
  end

end

# 表層形\t品詞,品詞細分類1,品詞細分類2,品詞細分類3,活用形,活用型,原形,読み,発音

# String^10 -> Morpheme(={:surface,:pos,:pos1,:base})
def morpheme(surface,
             pos,
             pos1,
             _品詞細分類2,
             _品詞細分類3,
             _活用形,
             _活用型,
             base,
             _読み,
             _発音)
  { surface: surface, pos: pos, pos1: pos1, base: base }
end

# String -> Morpheme
def parse_morpheme(line)
  surface, params = line.split("\t")
  morpheme(surface, *params.chomp.split(','))
end

# [String, ...] -> Sentence (=[Morpheme, ...])
def parse_sentence(lines)
  lines.map do |line|
    parse_morpheme(line)
  end
end

# String -> [Sentence, ...]
def parse_text(str)
  str.each_line.split("EOS\n").map do |lines|
    parse_sentence(lines)
  end
end

# () -> [Sentence, ...]
def analyzed_text
  File.open 'neko.txt.mecab' do |f|
    parse_text(f.read)
  end
end

# [Sentence, ...] -> ()
def dump_text(text)
  print '['
  text.proc_map { |s|
      print '['
      s.proc_map { |morph| print morph.inspect }
        .intersperse(-> { print "\n  " })
        .each(&:call)
      print ']'
  }.intersperse(-> { print ",\n " }).each(&:call)
  puts ']'
end

def morphemes(text)
  text.flatten(1)
end

def main
  dump_text(analyzed_text)
end

if __FILE__ == $0
  main
end

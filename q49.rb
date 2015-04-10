=begin

49. 名詞間の係り受けパスの抽出

=end

require 'pp'
require_relative 'q48'

Nominal_chunk_p = proc { |c| c.morphs.any?(&Noun_p) }

class Morph
  def inspect
    "#<Morph #{surface}>"
  end
end

require 'binding_of_caller'
class Symbol
  def as_method(receiver = binding.of_caller(1).eval('self'))
    receiver.method(self)
  end
end
    
def render_segment(chunks)
  chunks.map(&:unpunctuated_text).join(' -> ')
end

Punctuation_p = proc { |m| m.pos=='記号' }

def to_parameterized_text(chunk, identifier)
  idx = chunk.morphs.rindex(&Noun_p)
  raise 'no noun' unless idx
  
  tail = chunk.morphs[(idx + 1)..-1].reject(&Punctuation_p).map(&:surface)
  [identifier, *tail].join
end

def render_segment_parameterized_both(chunks)
  raise unless chunks.size >= 2
  fst = to_parameterized_text(chunks.first, 'X')
  lst = to_parameterized_text(chunks.last, 'Y')
  [fst, *chunks[1..-2].map(&:unpunctuated_text), lst].join(' -> ')
end

def render_segment_parameterized_first(chunks, variable)
  fst = to_parameterized_text(chunks.first, variable)
  [fst, *chunks[1..-1].map(&:unpunctuated_text)].join(' -> ')
end

def render_conjunction(seg1, seg2, joint)
  [render_segment_parameterized_first(seg1, 'X'),
   render_segment_parameterized_first(seg2, 'Y'),
   joint.unpunctuated_text].join(' | ')
end

def main
  doc = load_document
  doc.flat_map do |sent|
    sent.select(&Nominal_chunk_p).combination(2).each do |c1,c2|
      raise unless c1.id < c2.id
      # p [c1.text,c2.text]

      c1_path = path_to_root(c1, sent)
      c2_path = path_to_root(c2, sent)

      if c1_path.include?(c2)
        # p :case1
        prefix = c1_path.slice_before(&:==.as_method(c2)).first
        puts render_segment_parameterized_both(prefix + [c2])
      else
        # p :case2
        joint = (c1_path & c2_path).first
        seg1 = c1_path.slice_before(&:==.as_method(joint)).first
        seg2 = c2_path.slice_before(&:==.as_method(joint)).first
        # p [:seg1, seg1]
        # p [:seg2, seg2]
        
        puts render_conjunction(seg1, seg2, joint)
      end
    end
  end
end

main

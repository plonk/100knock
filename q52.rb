=begin

52. ステミング

=end

require 'fast-stemmer'

def trim_punctuation(word)
  word.sub(/\A[^[:alnum:]]+/, '')
    .sub(/[^[:alnum:]]+\z/, '')
end

`ruby q51.rb`.each_line.map(&:chomp).map(&method(:trim_punctuation)).each do |word|
  next if word.empty?
  puts "#{word}\t#{word.stem}"
end

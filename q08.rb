def cipher(str)
  str.each_char.map { |c|
    if c =~ /\A[a-z]\z/
      (219 - c.ord).chr
    else
      c
    end
  }.join
end

msg = "As a language becomes more expressive, its programs become less amenable to formal manipulation."
code = cipher(msg)

puts code
puts cipher(code)

raise unless cipher(code) == msg

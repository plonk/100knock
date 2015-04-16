def cipher(str)
  str.gsub(/[a-z]/) { |c| (219 - c.ord).chr }
end

msg = "As a language becomes more expressive, its programs become less amenable to formal manipulation."
code = cipher(msg)

puts code
puts cipher(code)

raise unless cipher(code) == msg

def table(str)
  str.each_line.to_a.map { |line| line.chomp.split("\t") }
end

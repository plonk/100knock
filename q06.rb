# 06. 集合

# "paraparaparadise"と"paragraph"に含まれる文字bi-gramの集合を，それぞ
# れ, XとYとして求め，XとYの和集合，積集合，差集合を求めよ．さら
# に，'se'というbi-gramがXおよびYに含まれるかどうかを調べよ．

def n_gram(seq, n)
  seq.each_cons(n).to_a
end

def char_bigram(str)
  n_gram(str.each_char,2).map(&:join)
end

def show(x, y)
  puts "X = %p" % [x]
  puts "Y = %p" % [y]
  puts "和集合 %p" % [x | y]
  puts "積集合 %p" % [x & y]
  puts "差集合 %p" % [x - y]

  puts "X は \"se\" を含む？ %p" % x.include?('se')
  puts "Y は \"se\" を含む？ %p" % y.include?('se')
end

w1 = 'paraparaparadise'
w2 = 'paragraph'

x = char_bigram(w1).uniq
y = char_bigram(w2).uniq

show(x, y)

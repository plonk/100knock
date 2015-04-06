# 05. n-gram

# 与えられたシーケンス（文字列やリストなど）からn-gramを作る関数を作成
# せよ．この関数を用い，"I am an NLPer"という文から単語bi-gram，文字
# bi-gramを得よ．

def n_gram(seq, n)
  seq.each_cons(n).to_a
end

p n_gram("I am an NLPer".each_char, 2)
p n_gram("I am an NLPer".split, 2)

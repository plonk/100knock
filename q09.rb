=begin
09. Typoglycemia

スペースで区切られた単語列に対して，各単語の先頭と末尾の文字は残し，そ
れ以外の文字の順序をランダムに並び替えるプログラムを作成せよ．ただし，
長さが４以下の単語は並び替えないこととする．適当な英語の文（例えば"I
couldn't believe that I could actually understand what I was reading :
the phenomenal power of the human mind ."）を与え，その実行結果を確認せ
よ．
=end

def shuffle_letters(str)
  str.each_char.to_a.shuffle.join
end

def typoglycemia(str)
  str.split(' ').map { |w|
    if w.size <= 4
      w
    else
      w[0] + shuffle_letters(w[1...-1]) + w[-1]
    end
  }.join(' ')
end

puts typoglycemia("I couldn't believe that I could actually understand what I was reading : the phenomenal power of the human mind .")

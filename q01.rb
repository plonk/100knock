# 01. 「パタトクカシーー」

# 「パタトクカシーー」という文字列の1,3,5,7文字目を取り出して連結した文
# 字列を得よ．

puts 'パタトクカシーー'.each_char.select.with_index { |c,i| i.even? }.join

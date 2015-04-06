=begin

26. 強調マークアップの除去

25の処理時に，テンプレートの値からMediaWikiの強調マークアップ（弱い強調，
強調，強い強調のすべて）を除去してテキストに変換せよ（参考: マークアッ
プ早見表）．

=end

require 'yaml'

def tokenize(str)
  str.scan(/(?:{{|}}|.)/m)
end

def toplevels(tokens)
  res = []
  buf = []
  level = 0

  while tok = tokens.shift
    if tok == '{{'
      buf << tok
      level += 1
    elsif tok == '}}'
      buf << tok
      level -= 1
      if level == 0
        res << buf.join
        buf = []
      end
    else
      buf << tok if level > 0
    end
  end

  res
end

def templates
  File.open("england.txt") do |f|
    str = f.read

    toplevels(tokenize(str))
  end
end

def basic_info
  templates.find { |s| s =~ /\A{{基礎情報/ }
end

def extract_dict(info)
  headers = info.each_line.to_a[1..-2]
  key = nil
  res = {}
  headers.each do |line|
    if line =~ /^\|(.+?) = (.*)$/
      key = $1
      res[key] = $2
    else
      res[key] += "\n" + line.chomp
    end
  end
  res
end

# 強調マークアップを取り除く。
def remove_markup(str)
  str
    .gsub(/'''''(.*)'''''/, '\1')
    .gsub(/'''(.*)'''/,     '\1')
    .gsub(/''(.*)''/,       '\1')
end

puts extract_dict(basic_info).map { |k,v| [k,remove_markup(v)] }.to_h.to_yaml

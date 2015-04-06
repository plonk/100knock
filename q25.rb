=begin

25. テンプレートの抽出

記事中に含まれる「基礎情報」テンプレートのフィールド名と値を抽出し，辞
書オブジェクトとして格納せよ．

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

puts extract_dict(basic_info).to_yaml

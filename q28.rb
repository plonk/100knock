=begin

28. MediaWikiマークアップの除去

27の処理に加えて，テンプレートの値からMediaWikiマークアップを可能な限り除去し，国の基本情報を整形せよ．

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
def remove_emphasis str
  str
    .gsub(/'''''(.*)'''''/, '\1')
    .gsub(/'''(.*)'''/,     '\1')
    .gsub(/''(.*)''/,       '\1')
end

# 内部リンクを普通のテキストにする。
def remove_internal_links str
  str
    .gsub(/\[\[([^\]]*)\]\]/) { $1.split('|').last }
end

def remove_external_links str
  str
    .gsub(/\[([^\]]*)\]/) { $1.split(' ', 2).last }
end

def remove_empty_elements str
  str
    .gsub(/<[a-z]+[^>]*\/>/, '')
end

def remove_templates str
  str
    .gsub(/{{([^}]+)}}/) { $1.split('|').last }
end

def inline_ref(str)
  str
    .gsub(/<ref[^>]*>([^<]+)<\/ref>/) { "(#{$1})" }
end

require 'htmlentities'

def resolve_character_entities(str)
  HTMLEntities.new.decode(str)
end

def remove_markup(str)
  resolve_character_entities inline_ref remove_external_links remove_templates remove_empty_elements remove_internal_links remove_emphasis str
end

def print_dict(dict)
  dict.each do |k,v|
    print "#{k}:\n"
    v.each_line do |line|
      print "\t"
      print line
    end
    puts
  end
end
print_dict extract_dict(basic_info).map { |k,v| [k,remove_markup(v)] }.to_h

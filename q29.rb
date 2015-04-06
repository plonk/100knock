=begin


29. 国旗画像のURLを取得する

テンプレートの内容を利用し，国旗画像のURLを取得せよ．（ヒント:
MediaWiki APIのimageinfoを呼び出して，ファイル参照をURLに変換すればよい）

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

require 'open-uri'
require 'cgi'
require 'json'

def query_image_url(filename)
  titles = 'File:' + CGI::escape(filename)
  resource = open("http://en.wikipedia.org/w/api.php?format=json&action=query&prop=imageinfo&iiprop=url&titles=#{titles}&continue=")
  json = JSON.load(resource.read)
  json['query']['pages'].values.first['imageinfo'].first['url']
end

dict = extract_dict(basic_info)
puts query_image_url(dict['国旗画像'])


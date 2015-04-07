task :download do
  urls = %w(http://www.cl.ecei.tohoku.ac.jp/nlp100/data/hightemp.txt http://www.cl.ecei.tohoku.ac.jp/nlp100/data/jawiki-country.json.gz http://www.cl.ecei.tohoku.ac.jp/nlp100/data/neko.txt)
  urls.each do |url|
    system('wget', '-c', url)
  end

  system('ruby q20.rb > england.txt')
  system('mecab neko.txt > neko.txt.mecab')
end

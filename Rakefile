task :download do
  urls = %w(http://www.cl.ecei.tohoku.ac.jp/nlp100/data/hightemp.txt http://www.cl.ecei.tohoku.ac.jp/nlp100/data/jawiki-country.json.gz)
  urls.each do |url|
    system('wget', '-c', url)
  end

  system('ruby q20.rb > england.txt')
end

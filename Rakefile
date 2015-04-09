task :download do
  urls = ['http://www.cl.ecei.tohoku.ac.jp/nlp100/data/hightemp.txt',
          'http://www.cl.ecei.tohoku.ac.jp/nlp100/data/jawiki-country.json.gz',
          'http://www.cl.ecei.tohoku.ac.jp/nlp100/data/neko.txt']
  urls.each do |url|
    puts "downloading #{url}"
    system('wget', '-qc', url)
  end

  puts 'creating england.txt'
  system('ruby q20.rb > england.txt')

  puts 'creating neko.txt.mecab'
  system('mecab neko.txt > neko.txt.mecab')

  puts 'creating neko.txt.cabocha'
  system 'cabocha -f 3 neko.txt > neko.txt.cabocha'
end

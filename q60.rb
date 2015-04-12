=begin

60. KVSの構築

Key-Value-Store (KVS) を用い，アーティスト名（name）から活動場所（area）
を検索するためのデータベースを構築せよ．

=end

require 'redis'
require 'json'
require 'pp'

def artist_json
  Enumerator.new do |y|
    File.open('artist.json') do |f|
      f.each_line.each do |line|
        y << JSON.load(line)
      end
    end
  end
end

db = Redis.new
STDERR.print 'flusing db...'
db.flushall
STDERR.puts 'ok'

artist_json.each.with_index(+1) do |artist, i|
  # オブジェクトを保存する
  id = artist["id"]
  args = artist.flat_map { |k,v| [k, v.is_a?(Array) ? v.to_json : v] }
  db.hmset "artist:#{id}", *args

  # name から id へのハッシュ
  if artist['name']
    db.rpush "name:#{artist['name']}", id
  end

  # area から id へのハッシュ
  if artist['area']
    db.rpush "area:#{artist['area']}", id
  end

  STDERR.puts "#{i} records saved" if i % 1000 == 0
end

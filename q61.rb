=begin

61. KVSの検索

60で構築したデータベースを用い，特定の（指定された）アーティストの活動
場所を取得せよ．

=end

require 'redis'
require 'json'
require 'pp'

def main
  raise "Usage: #{$0} [ARTIST]" unless ARGV.size == 1

  db = Redis.new

  name = ARGV[0]
  ids = db.lrange "name:#{name}", 0, -1
  ids.each do |id|
    puts "ID: #{id}"
    area = db.hget "artist:#{id}", 'area'
    puts area || '(n/a)'
    puts
  end
end

main if __FILE__ == $0

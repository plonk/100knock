=begin

63. オブジェクトを値に格納したKVS

KVSを用い，アーティスト名（name）からタグと被タグ数（タグ付けされた回数）
のリストを検索するためのデータベースを構築せよ．さらに，ここで構築した
データベースを用い，アーティスト名からタグと被タグ数を検索せよ．

=end


require 'redis'
require 'json'
require 'pp'

def main
  raise "Usage: #{$0} NAME" unless ARGV.size == 1

  name = ARGV[0]
  db = Redis.new

  ids = db.lrange "name:#{name}", 0, -1
  ids.each do |id|
    puts "ID: #{id}"

    tags = JSON.load(db.hget("artist:#{id}", 'tags'))
    if tags
      tags.each do |row|
        count, value = row.values_at('count', 'value')
        puts "\t#{count} #{value}"
      end
    else
      puts "\t(n/a)"
    end

    puts
  end

end

main if __FILE__ == $0

=begin

62. KVS内の反復処理

60で構築したデータベースを用い，活動場所が「Japan」となっているアーティ
スト数を求めよ．

=end

require 'redis'
require 'json'

def main
  db = Redis.new

  puts db.llen "area:Japan"
end

main if __FILE__ == $0

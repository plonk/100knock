=begin

65. MongoDBの検索

MongoDBのインタラクティブシェルを用いて，"Queen"というアーティストに関
する情報を取得せよ．さらに，これと同様の処理を行うプログラムを実装せよ．

> use mydb
> db.q64.find({ "name": "Queen" })

=end

require 'mongo'
require 'pp'

client = Mongo::Client.new('mongodb://localhost:27017/mydb')
client[:q64].find({ name: 'Queen' }).each do |artist|
  pp artist
end




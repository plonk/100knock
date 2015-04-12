=begin

66. 検索件数の取得

MongoDBのインタラクティブシェルを用いて，活動場所が「Japan」となってい
るアーティスト数を求めよ．

=end

require 'mongo'

client = Mongo::Client.new('mongodb://localhost:27017/mydb')
p client[:q64].find({ area: 'Japan' }).count.to_i


=begin

64. MongoDBの構築

アーティスト情報（artist.json.gz）をデータベースに登録せよ．さらに，次
のフィールドでインデックスを作成せよ: name, aliases.name, tags.value,
rating.value

=end

require 'mongo'
require 'json'

def artist_json
  Enumerator.new do |y|
    File.open('artist.json') do |f|
      f.each_line.each do |line|
        y << JSON.load(line)
      end
    end
  end
end

client = Mongo::Client.new('mongodb://localhost:27017/mydb')
coll = client.database.collection('q64')
coll.drop
coll = client.database.collection('q64')

coll.indexes.create_many([{ key: { name: 1 } },
                          { key: { :"aliases.name" => 1 } },
                          { key: { :"tags.value" => 1 } },
                          { key: { :"rating.value" => 1 } }, ] )

artist_json.each_slice(1000) do |slice|
  coll.insert_many(slice)
end

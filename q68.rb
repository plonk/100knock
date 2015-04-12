=begin

68. ソート

"dance"というタグを付与されたアーティストの中でレーティングの投票数が多
いアーティスト・トップ10を求めよ．

=end

require 'mongo'
require 'pp'

def main
  client = Mongo::Client.new('mongodb://localhost:27017/mydb')

  client[:q64].find({ :"tags.value" => 'dance' }).sort({ :'rating.value' => -1 }).limit(10)
    .each.with_index(1) do |artist, place|
    puts "#{place}. #{artist['name']}"
  end
end

main if __FILE__ == $0


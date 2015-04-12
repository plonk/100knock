=begin

67. 複数のドキュメントの取得

特定の（指定した）別名を持つアーティストを検索せよ．

=end

require 'mongo'
require 'pp'

def main
  raise "usage: #{$0} ALIAS" unless ARGV.size == 1

  client = Mongo::Client.new('mongodb://localhost:27017/mydb')

  client[:q64].find({ :"aliases.name" => ARGV[0] }).each do |artist|
    pp artist
  end
end

main if __FILE__ == $0

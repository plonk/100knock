=begin

69. Webアプリケーションの作成

ユーザから入力された検索条件に合致するアーティストの情報を表示するWebア
プリケーションを作成せよ．アーティスト名，アーティストの別名，タグ等で
検索条件を指定し，アーティスト情報のリストをレーティングの高い順などで
整列して表示せよ．

=end

require 'mongo'
require 'sinatra'
require 'active_support'
require 'active_support/core_ext'

$mongo_cli = Mongo::Client.new('mongodb://localhost:27017/mydb')

get '/' do
  <<EOS
<form action="/search" method="GET">
アーティスト名: <input type="text" name="name"><br>
別名: <input type="text" name="alias"><br>
タグ: <input type="text" name="tag"><br>
<select name="order_field">
  <option value="name">アーティスト名</option>
  <option value="rating.value" selected>レーティング</option>
</select>
<select name="order">
  <option value="1">昇順</option>
  <option value="-1" selected>降順</option>
</select>
<input type="submit">
</form>
EOS
end

get '/search' do
  query = search_query(params.slice('name', 'alias', 'tag'))
  order = search_order(params.slice('order_field', 'order'))
  p [query, order]
  artists = $mongo_cli[:q64].find(query).sort(order).limit(100)
  return search_result(artists)
end

def search_result(artists)
  buf = ''
  buf << "<table>"
  buf << "<tr><td>ID</td><td>アーティスト名</td><td>レーティング</td></tr>"
  artists.each do |a|
    if a['rating']
      rating = a['rating']['value']
    else
      rating = 'n/a'
    end
    buf << "<tr><td>#{a['id']}</td><td>#{a['name']}</td><td>#{rating}</td></tr>"
  end
  buf << "</table>"
  buf
end

def search_query(opt)
  name, alias_, tag = opt.values_at('name', 'alias', 'tag')

  query = {}
  query = query.merge({ name: name }) unless name.blank?
  query = query.merge({ :"aliases.name" => alias_ }) unless alias_.blank?
  query = query.merge({ :"tags.value" => tag }) unless tag.blank?
  query
end

def search_order(opt)
  order_field, order = opt.values_at('order_field', 'order')

  { order_field.to_sym => order.to_i }
end

# coding:utf-8
require 'active_record'
require 'mysql2'
require 'sinatra'

# DB設定ファイルの読み込み
ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection(:production)

class User < ActiveRecord::Base
end

# 登録されているユーザーを取得
get '/users' do
  content_type :json, :charset => 'utf-8'
  users = User.all
  users.to_json(:root => false) # :root => false は json で返却した時に json の一番上のキーが user にならないようにする
end

get '/' do
  'Hello world!'
end

# 新規登録
post '/users' do
  # リクエスト解析
  json = JSON.parse(request.body.read.to_s)
  id = json['id']


  if User.find_by(id: id)
    status 400
    { :result => "error", :code => 400, :message => "IDが既に存在します" }.to_json
  else
    user = User.new(json)
    if user.save
      status 200
      { :result => "success", :code => 200 }.to_json
    else
      status 400
      { :result => "error", :code => 400, :message => "もう一度やり直してください" }.to_json
    end
  end
end

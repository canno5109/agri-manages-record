# coding:utf-8
require 'active_record'
require 'mysql2'
require 'sinatra'

# DB設定ファイルの読み込み
ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection(:production)

class Record < ActiveRecord::Base
end

class User < ActiveRecord::Base
end

# 登録されているユーザーを取得
get '/records' do
  content_type :json, :charset => 'utf-8'
  records = Record.all
  records.to_json(:root => false)
end

get '/r' do
  'Hello world!'
end

# 新規登録
post '/records' do
  # リクエスト解析
  json = JSON.parse(request.body.read.to_s)
  user_id = json['user_id']
  filename = json['file'].extension
  puts filename
  puts json['file'].filename

  if User.find_by(id: user_id)
    record = Record.new(json)
    if record.save
      status 200
      { :result => "success", :code => 200 }.to_json
    else
      status 400
      { :result => "error", :code => 400, :message => "エラーが発生しました" }.to_json
    end
  else
    status 400
    { :result => "error", :code => 400, :message => "IDが存在しません" }.to_json
  end
end

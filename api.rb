require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require './models/app'

set :database, {adapter: "sqlite3", database: "foo.sqlite3"}

set :public_folder, './images'

before do
  content_type :json
end

#ROUTES
get '/apps' do
  apps = App.all
  unless apps.empty?
    apps.to_json(:except => [ :created_at, :updated_at ])
  else
    halt 404
  end
end

get '/apps/:id' do |id|
  app = App.find_by_id(id)
  if app
    app.to_json
  else
    halt 404
  end
end

post '/apps' do
  begin
    values = JSON.parse(request.env["rack.input"].read)
    app = App.new
    app.name = values['name']
    app.description = values['description']
    if app.save
      status 201
      app.to_json
    else
      status 409
      {error: "409 Conflict"}.to_json
    end
  rescue JSON::ParserError => e
    status 400
    {error: "400 Bad Request"}.to_json
  end
end

put '/apps/:id' do |id|
  begin
    values = JSON.parse(request.env["rack.input"].read)
    app = App.find_by_id(id)
    if app
      app.name = values['name']
      app.description = values['description']
      if app.save
        app.to_json
      else
        status 409
        {error: "409 Conflict"}.to_json
      end 
    else
      halt 404
    end
  rescue JSON::ParserError => e
    status 400
    {error: "400 Bad Request"}.to_json
  end
end

delete '/apps/:id' do |id|
  app = App.find_by_id(id)
  if app
    if app.destroy
      status 204
      ""
    else
      status 409
      {error: "409 Conflict"}.to_json
    end
  else
    halt 404
  end
end

not_found do
  response = Hash.new
  response["error"] = "404 Not found."
  response.to_json
end

error do
  response = Hash.new
  response["error"] = "500 BOOM!"
  response.to_json
end
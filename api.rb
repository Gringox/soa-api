require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require './models/app'

set :database, {adapter: "sqlite3", database: "foo.sqlite3"}

before do
	content_type :json
end

#ROUTES
get '/apps' do
	response = Hash.new

	apps = App.all

	if apps
		apps.to_json(:except => [ :created_at, :updated_at ])
	else
		response["error"] = "There's no apps"
		response.to_json
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
	app = App.new(params)

	if app.save
		status 201
		app.to_json
	else
		halt 500
	end
end

put '/apps/:id' do |id|
	response = Hash.new
	app = App.find_by_id(id)

	if app
		app.name = params[:name]
		app.description = params[:description]
		if app.save
			app.to_json
		else
			halt 500
		end	
	else
		halt 500
	end
end

delete '/apps/:id' do |id|
	app = App.find_by_id(id)

	if app.destroy
		{:success => "ok"}.to_json
	else
		halt 500
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
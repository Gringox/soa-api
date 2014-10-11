require "sinatra"
require "sinatra/json"
require "json"

# define a route that uses the helper
get '/' do
  json :foo => 'bar'
end
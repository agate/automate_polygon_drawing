require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/content_for'
require 'haml'

require 'factual'

set :haml, :format => :html5

API = Factual.new(ENV['KEY'], ENV['SECRET'])

def search(q)
  API.table('places').search(q).rows
end

get '/' do
  unless params[:q].nil?
    @places = search(params[:q])
  end

  haml :index
end

get '/draw' do
  lat = params[:lat]
  lng = params[:lng]

  haml :draw
end

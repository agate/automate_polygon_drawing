require 'rubygems'
require 'bundler/setup'

require 'ostruct'
require 'open3'

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

def generate_map_png(lat, lng)
  dir = File.expand_path('../../image_dumper', __FILE__)
  Open3.popen3("./run.sh", lat, lng, chdir: dir) do |i,o,e,t|
    p o.read.chomp.inspect
  end
end

def generate_polygon_points
  dir = File.expand_path('../../image_to_polygen', __FILE__)
  map_png = File.expand_path('../../image_dumper/map.png', __FILE__)
  Open3.popen3("./run.octave.sh", map_png, chdir: dir) do |i,o,e,t|
    p o.read.chomp.inspect
  end

  File.read("#{dir}/points").lines.map do |line|
    line.strip.split(/\s+/).map { |x| x.to_i }
  end
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

  generate_map_png(lat, lng)

  @points = generate_polygon_points
  haml :draw
end

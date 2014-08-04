require 'rubygems'
require 'bundler/setup'

require 'ostruct'
require 'open3'
require 'fileutils'

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

def get_output_dir(lat, lng, satellite)
  File.expand_path("../../results/#{lat}+#{lng}+#{satellite}", __FILE__)
end

# step 1
def generate_map_png(output_dir, lat, lng, satellite)
  dir = File.expand_path('../../image_dumper', __FILE__)
  Open3.popen3("./run.sh", lat, lng, satellite, output_dir, chdir: dir) do |i,o,e,t|
    o.read #placeholder
  end
end

# step 2
def generate_polygon_points(output_dir, satellite="true")
  dir = File.expand_path('../../image_to_polygen', __FILE__)
  map_png = "#{output_dir}/map.png"
  Open3.popen3("./run.octave.sh", map_png, satellite, chdir: dir) do |i,o,e,t|
    File.write("#{output_dir}/points", o.read.chomp)
  end
end

# step 3
def order_polygon_points(output_dir)
  dir = File.expand_path('../../sample_selector', __FILE__)
  points_file = "#{output_dir}/points"

  Open3.popen3('python', 'sample_selector.py', points_file, '3', chdir: dir) do |i,o,e,t|
    ordered_points = o.readlines.map do |line|
      line.strip.split(/\s+/).map { |x| x.to_i }
    end
    File.write("#{output_dir}/ordered_points.json", ordered_points.to_json)
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
  satellite = (params[:satellite] != 'false').to_s

  output_dir = get_output_dir(lat, lng, satellite)
  FileUtils.mkdir_p(output_dir)

  unless File.exists?("#{output_dir}/ordered_points.json")
    generate_map_png(output_dir, lat, lng, satellite)
    generate_polygon_points(output_dir, satellite)
    order_polygon_points(output_dir)
  end

  @points = JSON.parse(File.read("#{output_dir}/ordered_points.json"))

  haml :draw
end

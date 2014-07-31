require 'rubygems'
require 'bundler/setup'

require 'ostruct'

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

def five_start_points(center, outerradius, innerradius)
  ang36 = Math::PI / 5.0   # 36° x PI/180
  ang72 = 2.0 * ang36      # 72° x PI/180

  sin36 = Math.sin(ang36)
  sin72 = Math.sin(ang72)
  cos36 = Math.cos(ang36)
  cos72 = Math.cos(ang72)

  # Fill array with 10 origin points
  pnts = []; 10.times { pnts << center.clone }
  pnts[0].Y -= outerradius  # top off the star, or on a clock this is 12:00 or 0:00 hours
  pnts[1].X += innerradius * sin36; pnts[1].Y -= innerradius * cos36 # 0:06 hours
  pnts[2].X += outerradius * sin72; pnts[2].Y -= outerradius * cos72 # 0:12 hours
  pnts[3].X += innerradius * sin72; pnts[3].Y += innerradius * cos72 # 0:18
  pnts[4].X += outerradius * sin36; pnts[4].Y += outerradius * cos36 # 0:24 

  # Phew! Glad I got that trig working.
  pnts[5].Y += innerradius

  # I use the symmetry of the star figure here
  pnts[6].X += pnts[6].X - pnts[4].X; pnts[6].Y = pnts[4].Y # mirror point
  pnts[7].X += pnts[7].X - pnts[3].X; pnts[7].Y = pnts[3].Y # mirror point
  pnts[8].X += pnts[8].X - pnts[2].X; pnts[8].Y = pnts[2].Y # mirror point
  pnts[9].X += pnts[9].X - pnts[1].X; pnts[9].Y = pnts[1].Y # mirror point

  return pnts
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

  @points = five_start_points(OpenStruct.new(
    # X: 569.8762865662575,
    # Y: 300.0322458855808
    X: 10,
    Y: 10
  ), 100, 50).map do |p|
    [ p.X, p.Y ]
  end

  haml :draw
end

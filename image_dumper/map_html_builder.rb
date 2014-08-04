require 'rubygems'
require 'bundler/setup'

require 'optparse'
require 'yaml'

require 'haml'
require 'json'

lat = ARGV[0]
lng = ARGV[1]
satellite = ARGV[2] == 'true'

CONFIG = YAML.load(File.read(File.expand_path('../config.yml', __FILE__)))
MAP_HTML_TEMPLATE_PATH = File.expand_path('../map.html.haml', __FILE__)

def render(lat, lng, satellite)
  ext_config = {
    'lat'         => lat,
    'lng'         => lng,
    'map_type_id' => satellite ? 'SATELLITE' : 'ROADMAP'
  }

  Haml::Engine.new(File.read(MAP_HTML_TEMPLATE_PATH))
              .render(Object.new, config: CONFIG.merge(ext_config))
end

puts render(lat, lng, satellite)

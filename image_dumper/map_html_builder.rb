require 'rubygems'
require 'bundler/setup'

require 'optparse'
require 'yaml'

require 'haml'
require 'json'

lat = ARGV[0]
lng = ARGV[1]

CONFIG = YAML.load(File.read(File.expand_path('../config.yml', __FILE__)))
MAP_HTML_TEMPLATE_PATH = File.expand_path('../map.html.haml', __FILE__)

def render(lat, lng)
  ext_config = { 'lat' => lat, 'lng' => lng }
  template = File.read(MAP_HTML_TEMPLATE_PATH)
  Haml::Engine.new(template)
              .render(Object.new, config: CONFIG.merge(ext_config))
end

puts render(lat, lng)

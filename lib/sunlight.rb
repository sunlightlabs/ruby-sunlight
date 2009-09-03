require 'rubygems'
require 'json'
require 'cgi'
require 'ym4r/google_maps/geocoding'
require 'net/http'
include Ym4r::GoogleMaps

require "#{File.dirname(__FILE__)}/sunlight/base.rb"
Dir["#{File.dirname(__FILE__)}/sunlight/*.rb"].each { |source_file| require source_file }

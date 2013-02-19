require 'json'

# Sunlight::Base
require "#{File.dirname(__FILE__)}/sunlight/base.rb"

# Load in deprecated classes/methods
Dir["#{File.dirname(__FILE__)}/sunlight/deprecated/*.rb"].each { |source_file| require source_file }

# New files
Dir["#{File.dirname(__FILE__)}/sunlight/*.rb"].each { |source_file| require source_file }
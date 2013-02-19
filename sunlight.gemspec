Gem::Specification.new do |s|
  s.name = "sunlight"
  s.version = "2.0.0"
  s.date = "2013-02-19"
  s.summary = "Client for the Sunlight Congress API."
  s.description = "Client for the Sunlight Congress API."
  s.email = "api@sunlightfoundation.com"
  s.homepage = "http://github.com/sunlightlabs/ruby-sunlight"
  s.authors = ["Luigi Montanez", "Eric Mill", "Sunlight Foundation"]
  s.files = [
    'sunlight.gemspec', 
    'lib/sunlight.rb', 
    'lib/sunlight/base.rb',
    'lib/sunlight/district.rb', 
    'lib/sunlight/legislator.rb',
    'lib/sunlight/committee.rb', 
    'README.textile', 
    'CHANGES.textile'
  ]

  s.add_dependency "json", [">= 1.1.3"]
  s.add_dependency "ym4r", [">= 0.6.1"]
end
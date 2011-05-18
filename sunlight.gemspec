Gem::Specification.new do |s|
  s.name = "sunlight"
  s.version = "1.0.7"
  s.date = "2010-06-11"
  s.summary = "Library for accessing the Sunlight Labs API."
  s.description = "Library for accessing the Sunlight Labs API."
  s.rubyforge_project = "sunlight"
  s.email = "luigi@sunlightfoundation.com"
  s.homepage = "http://github.com/sunlightlabs/ruby-sunlightapi/"
  s.authors = ["Luigi Montanez"]
  s.files = ['sunlight.gemspec', 'lib/sunlight.rb', 'lib/sunlight/base.rb',
             'lib/sunlight/district.rb', 'lib/sunlight/legislator.rb',
             'lib/sunlight/committee.rb', 'README.textile', 'CHANGES.textile']
  s.add_dependency("json", [">= 1.1.3"])
  s.add_dependency("ym4r", [">= 0.6.1"])
  s.has_rdoc = true
end
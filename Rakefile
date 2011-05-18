require 'rubygems'
require 'rake'
require 'rake/rdoctask'
require 'rspec'
require 'rspec/core/rake_task'
require 'rcov/rcovtask'

Version = '0.1.0'

desc "Run specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = ["--colour", "--format", "documentation"]
end

desc 'Performs code coverage via rake rcov'
Rcov::RcovTask.new do |t|
  t.test_files = FileList['spec/*_spec.rb']
  t.verbose = true
end

desc 'Generate RDoc documentation'
Rake::RDocTask.new(:rdoc) do |rdoc|
  files = ['README.textile', 'CHANGES.textile', 'lib/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main     = "README.textile"
  rdoc.title    = "sunlight"
  rdoc.rdoc_dir = 'doc'
  rdoc.options << '--inline-source'
end

desc "Clean files generated by rake tasks"
task :clobber => [:clobber_rdoc, :clobber_rcov]

task :default => [:spec]

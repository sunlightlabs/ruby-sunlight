require 'rubygems'
require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'

Version = '0.1.0'

Spec::Rake::SpecTask.new("spec") do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['--color']
  t.rcov = true
  t.rcov_opts = ['--exclude', '^spec,/gems/']
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
  
task :default => [:spec]
require 'rubygems'
require 'rake'
require 'echoe'
require 'rake/testtask'
require 'rake/rdoctask'
require 'spec'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the gem.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'spec/pagem_spec.rb'
  t.verbose = true
end

Echoe.new('pagem', '1.0.4') do |p|
  p.description                       = "Pagination helper that works off of scopes (named) to facilitate data retrieval and display."
  p.url                               = "http://github.com/mdsol/pagem"
  p.author                            = "Ben Young"
  p.email                             = "byoung@mdsol.com"
  p.ignore_pattern                    = []
  p.development_dependencies          = ['rails =2.3.4']
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

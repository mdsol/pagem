require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('pagem', '1.0.0') do |p|
  p.description                       = "Pagination helper that works off of scopes (named) to facilitate data retrieval and display."
  p.url                               = "http://github.com/mdsol/pagem"
  p.author                            = "David Fenster"
  p.email                             = "dfenster@mdsol.com"
  p.ignore_pattern                    = []
  p.development_dependencies          = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

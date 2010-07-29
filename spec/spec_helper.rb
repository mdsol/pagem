ENV['RAILS_ENV'] = 'test'

rails_root = File.dirname(__FILE__) + '/../rails_root'
migration_dir= "#{rails_root}/db/migrate"

require "#{rails_root}/config/environment.rb"

require 'rails_generator'
require 'rails_generator/scripts/generate'
require 'rails_generator/scripts/destroy'
require 'fileutils'
require 'ruby-debug'
require 'spec'
Debugger.start

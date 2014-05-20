ENV['RAILS_ENV'] = 'test'

rails_root = File.dirname(__FILE__) + '/../rails_root'
migration_dir= "#{rails_root}/db/migrate"

require "#{rails_root}/config/environment.rb"
require 'fileutils'
require 'ruby-debug'

module MedidataButtonsHelpers
end

Debugger.start


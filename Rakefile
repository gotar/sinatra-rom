require 'bundler/setup'
require 'rom/sql/rake_task'
require_relative 'db/db'

task :setup do
  require_relative 'db/db'
  DB.setup
end

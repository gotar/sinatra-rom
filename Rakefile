require 'bundler/setup'
require 'rom-sql'
require 'rom/sql/rake_task'

require_relative 'db/setup'

namespace :db do
  task :load_setup do
    ROM::SQL::Migration.connection = DB.setup_connection_to_db
  end
end

module DB
  extend self

  def setup
    setup_connection_to_db
    load_files

    ROM.finalize.env
    ROM.env.repositories[:default].run_migrations
  end

  def setup_connection_to_db
    case ENV.fetch('RACK_ENV', 'development')
    when 'production'
      production_settings
    else
      dev_settings
    end.default.connection
  end

  private
  def production_settings
    require 'pg'
    host = ENV.fetch('POSTGRESQL_HOST')
    db = ENV.fetch('POSTGRESQL_DATABASE')
    user = ENV.fetch('POSTGRESQL_USER')
    password = ENV.fetch('POSTGRESQL_PASSWORD')
    ROM.setup(:sql, "postgres://#{host}/#{db}?user=#{user}&password=#{password}")
  end

  def dev_settings
    require 'sqlite3'
    ROM.setup(:sql, 'sqlite::memory')
  end

  def load_files
    %w(models params validators commands mappers relations).each do |dir|
      paths = File.join(root, dir, '**', '*.rb')
      Dir[paths].each{|file| require file}
    end
  end

  def root
    File.dirname __FILE__
  end
end

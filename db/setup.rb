require 'sqlite3'
require 'rom-sql'

module DB
  extend self

  def setup
    load(root+'/../Rakefile')
    Rake::Task["db:migrate"].invoke

    load_files

    ROM.finalize.env
  end

  def setup_connection_to_db
    ROM.setup(:sql, "sqlite::memory").default.connection
  end

  private
  def load_files
    %w(users products).each do |m|
      load(root+"/../apps/api/commands/#{m}.rb")
      load(root+"/../apps/api/mappers/#{m}.rb")
      load(root+"/../apps/api/relations/#{m}.rb")
    end
  end

  def root
    File.dirname __FILE__
  end
end

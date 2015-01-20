module DB
  extend self

  def setup
    setup = ROM.setup(sqlite: "sqlite::memory")

    setup.sqlite.connection.create_table(:products) do
      primary_key :id
      String :name
    end

    setup.sqlite.connection.create_table(:users) do
      primary_key :id
      String :email
      String :password_hash
      String :token
    end

    load_files

    ROM.finalize.env
  end

  private
  def load_files
    %w(users products).each do |m|
      load(root+"/../commands/#{m}.rb")
      load(root+"/../mappers/#{m}.rb")
      load(root+"/../relations/#{m}.rb")
    end
  end

  def root
    File.dirname __FILE__
  end
end

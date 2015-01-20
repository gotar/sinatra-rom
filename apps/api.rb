require 'virtus'
require 'rom-sql'
require 'sqlite3'
require_relative 'api/product_app'
require_relative 'api/user_app'
require_relative 'api/session_app'
require_relative 'api/lib/db'

module API
  class App < Sinatra::Base
    configure do
      DB.setup
    end

    use API::ProductApp
    use API::UserApp
    use API::SessionApp
  end
end

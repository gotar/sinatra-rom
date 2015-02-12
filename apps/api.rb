require 'virtus'
require_relative 'api/product_app'
require_relative 'api/user_app'
require_relative 'api/session_app'
require_relative '../db/setup'

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

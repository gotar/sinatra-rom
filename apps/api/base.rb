require_relative 'lib/helpers'
require_relative 'lib/http_basic_authorization'

module API
  class Base < Sinatra::Base
    helpers API::Helpers
    include HttpBasicAuthorization

    before do
      require_ssl!
      authorize_api!
    end
  end
end

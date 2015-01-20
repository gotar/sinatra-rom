ENV['RACK_ENV'] = 'test'

require 'rack/test'
require_relative '../app'
require_relative 'support/api_over_https_with_basic_auth'
require_relative 'helpers/test_helpers'
require 'database_cleaner'

Sinatra::Base.set :environment, :test
Sinatra::Base.set :raise_errors, true
Sinatra::Base.set :logging, false

module AppSetup
  include Credentials

  def self.included(base)
    base.instance_eval do
      include Rack::Test::Methods
    end
  end

  def app
    App
  end

  private
  def json_response
    @json_response ||= ::MultiJson.load(last_response.body)
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.before(:suite) do
    ::BCrypt::Engine.cost = ::BCrypt::Engine::MIN_COST
  end

  config.include TestHelpers
end

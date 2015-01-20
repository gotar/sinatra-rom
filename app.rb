require 'rubygems'
require 'bundler/setup'

require 'sinatra/base'
require 'dotenv'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/slice'
require 'active_support/inflector'

require_relative 'apps/api'
require_relative 'apps/heartbeat'

Dotenv.load

class App < Sinatra::Base
  enable :sessions, :protection
  set :session_secret, ENV['SECRET']

  use Rack::Deflater

  get '/' do
    redirect('/status')
  end

  use Heartbeat
  use API::App
end

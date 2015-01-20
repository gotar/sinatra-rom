class Heartbeat < Sinatra::Base
  get '/status' do
    'OK'
  end
end

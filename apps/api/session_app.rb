require_relative 'base'

module API
  class SessionApp < API::Base
    get '/login' do
      if user = rom.read(:users).login_by(params['email']).first
        json_error(401, "Invalid password for user: #{params['email']}") unless user.password == params['password']
        json({users: {token: user.token}})
      else
        record_not_found([params['email'], params['password']], [:email, :password])
      end
    end
  end
end

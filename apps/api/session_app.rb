require_relative 'base'

module API
  class SessionApp < API::Base
    get '/login' do
      begin
        SessionValidator.call(params)
        user = rom.relation(:users).login_by(params['email']).map_with(:users).one!
        json_error(401, "Invalid password for user: #{params['email']}") unless user.password == params['password']
        json({users: {access_token: user.token}})
      rescue ROM::TupleCountMismatchError
        record_not_found([params['email'], params['password']], [:email, :password])
      rescue ValidationError => e
        invalid_params(e.params)
      end
    end
  end
end

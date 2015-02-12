require_relative 'base'
require_relative 'models/user'
require_relative 'validators/user_validator'

module API
  class UserApp < API::Base
    get '/users' do
      users = rom.read(:users).all.to_a
      json(users: users)
    end

    get '/users/:id' do |id|
      begin
        user = rom.read(:users).by_id(id).one!
        json(users: user)
      rescue ROM::TupleCountMismatchError
        record_not_found(id)
      end
    end

    post '/users' do
      begin
        attrs = params.slice('email', 'password')
        result = rom.command(:users).create.call(attrs)
        status 201
        json(users: result)
      rescue ValidationError => e
        json_error(422, e.message)
      end
    end

    patch '/users/:id' do |id|
      attrs = params.slice('email', 'password')
      result = rom.command(:users).update.by_id(id).set(attrs)
      result ? json(users: result) : record_not_found(id)
    end

    delete '/users/:id' do |id|
      result = rom.command(:users).delete.by_id(id).call
      result ? json({message: 'OK'}) : record_not_found(id)
    end
  end
end

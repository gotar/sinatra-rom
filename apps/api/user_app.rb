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
      if user = rom.read(:users).by_id(id).first
        json(users: user)
      else
        record_not_found(id)
      end
    end

    post '/users' do
      begin
      attrs = params.slice('email', 'password')
      result = rom.command(:users).try { create(attrs) }
      status 201
      json(users: result.value)
      rescue ValidationError => e
        json_error(422, e.message)
      end
    end

    patch '/users/:id' do |id|
      begin
        attrs = params.slice('email', 'password')
        result = rom.command(:users).try { update(:by_id, id).set(attrs) }
        json(users: result.value)
      rescue Sequel::DatabaseError => e
        record_not_found(id)
      end
    end

    delete '/users/:id' do |id|
      result = rom.command(:users).try { delete(:by_id, id) }
      result.value ? json({message: 'OK'}) : record_not_found(id)
    end
  end
end

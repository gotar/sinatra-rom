require_relative 'base'
require_relative 'models/user'
require_relative 'serializers/user_serializer'

module API
  class UserApp < API::Base
    get '/users' do
      users = ROM.env.read(:users).all
      json ::API::UserSerializer.multi(users)
    end

    get '/users/:id' do |id|
      if user = ROM.env.read(:users).by_id(id).first
        json ::API::UserSerializer.single(user)
      else
        record_not_found(id)
      end
    end

    post '/users' do
      require_fields([:email, :password])
      attrs = params.slice('email', 'password')
      result = ROM.env.command(:users).try { create(attrs) }
      status 201
      json ::API::UserSerializer.single(result.value)
    end

    patch '/users/:id' do |id|
      begin
        attrs = params.slice('email', 'password')
        result = ROM.env.command(:users).try { update(:by_id, id).set(attrs) }
        json ::API::UserSerializer.single(result.value)
      rescue Sequel::DatabaseError => e
        record_not_found(id)
      end
    end

    delete '/users/:id' do |id|
      result = ROM.env.command(:users).try { delete(:by_id, id) }
      result.value ? json({message: 'OK'}) : record_not_found(id)
    end
  end
end

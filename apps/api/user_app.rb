require_relative 'base'

module API
  class UserApp < API::Base
    get '/users' do
      users = rom.relation(:users).ordered.to_a
      json(users: users)
    end

    get '/users/:id' do |id|
      begin
        user = rom.relation(:users).by_id(id).one!
        json(users: user)
      rescue ROM::TupleCountMismatchError
        record_not_found(id)
      end
    end

    post '/users' do
      begin
        SessionValidator.call(params)
        result = rom.command(:users).try do
          rom.command(:users).create.call(params)
        end
        raise ROM::Error.new(result.error) if result.error
        status 201
        json(users: result.value)
      rescue ValidationError => e
        invalid_params(e.params)
      rescue ROM::Error => e
        json_error(422, e.message)
      end
    end

    patch '/users/:id' do |id|
      begin
        user = rom.relation(:users).by_id(id).one!
        attrs = user.merge(params.symbolize_keys)
        SessionValidator.call(attrs) if attrs[:password]
        result = rom.command(:users).try do
          rom.command(:users).update.by_id(id).set(attrs)
        end
        json(users: result.value)
      rescue ValidationError => e
        invalid_params(e.params)
      rescue Sequel::DatabaseError => e
        json_error(422, e.message)
      rescue ROM::TupleCountMismatchError
        record_not_found(id)
      end
    end

    delete '/users/:id' do |id|
      result = rom.command(:users).try do
        rom.command(:users).delete.by_id(id).call
      end
      result.value ? delete_response : record_not_found(id)
    end
  end
end

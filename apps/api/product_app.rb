require_relative 'base'
require_relative 'models/product'
require_relative 'serializers/product_serializer'

module API
  class ProductApp < API::Base
    get '/products' do
      products = ROM.env.read(:products).all
      json ::API::ProductSerializer.multi(products)
    end

    get '/products/:id' do |id|
      if product = ROM.env.read(:products).by_id(id).first
        json ::API::ProductSerializer.single(product)
      else
        record_not_found(id)
      end
    end

    post '/products' do
      require_fields([:name])
      attrs = params.slice('name')
      result = ROM.env.command(:products).try { create(attrs) }
      status 201
      json ::API::ProductSerializer.single(result.value)
    end

    patch '/products/:id' do |id|
      begin
        attrs = params.slice('name')
        result = ROM.env.command(:products).try { update(:by_id, id).set(attrs) }
        json ::API::ProductSerializer.single(result.value)
      rescue Sequel::DatabaseError => e
        record_not_found(id)
      end
    end

    delete '/products/:id' do |id|
      result = ROM.env.command(:products).try { delete(:by_id, id) }
      result.value ? json({message: 'OK'}) : record_not_found(id)
    end
  end
end

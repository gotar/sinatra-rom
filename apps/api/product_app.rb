require_relative 'base'
require_relative 'models/product'
require_relative 'validators/product_validator'

module API
  class ProductApp < API::Base
    get '/products' do
      products = rom.read(:products).all.to_a
      json({products: products})
    end

    get '/products/:id' do |id|
      if product = rom.read(:products).by_id(id).first
        json({products: product})
      else
        record_not_found(id)
      end
    end

    post '/products' do
      begin
        attrs = params.slice('name')
        result = rom.command(:products).try { create(attrs) }
        status 201
        json({products: result.value})
      rescue ValidationError => e
        json_error(422, e.message)
      end
    end

    patch '/products/:id' do |id|
      begin
        attrs = params.slice('name')
        result = rom.command(:products).try { update(:by_id, id).set(attrs) }
        json({products: result.value})
      rescue Sequel::DatabaseError => e
        record_not_found(id)
      end
    end

    delete '/products/:id' do |id|
      result = rom.command(:products).try { delete(:by_id, id) }
      result.value ? json({message: 'OK'}) : record_not_found(id)
    end
  end
end

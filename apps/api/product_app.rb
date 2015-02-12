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
      begin
        product = rom.read(:products).by_id(id).one!
        json({products: product})
      rescue ROM::TupleCountMismatchError
        record_not_found(id)
      end
    end

    post '/products' do
      begin
        attrs = params.slice('name')
        result = rom.command(:products).create.call(attrs)
        status 201
        json({products: result})
      rescue ValidationError => e
        json_error(422, e.message)
      end
    end

    patch '/products/:id' do |id|
      attrs = params.slice('name')
      result = rom.command(:products).update.by_id(id).set(attrs)
      result ? json({products: result}) : record_not_found(id)
    end

    delete '/products/:id' do |id|
      result = rom.command(:products).delete.by_id(id).call
      result ? json({message: 'OK'}) : record_not_found(id)
    end
  end
end

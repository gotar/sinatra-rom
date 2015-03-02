require_relative 'base'

module API
  class ProductApp < API::Base
    get '/products' do
      begin
        attrs = PaginationParams.new(params)
        PaginationValidator.call(attrs)
        products = rom.relation(:products).ordered
          .page(attrs.page).per_page(attrs.per_page).to_a
        json(products: products)
      rescue ValidationError => e
        invalid_params(e.params)
      end
    end

    get '/products/:id' do |id|
      begin
        product = rom.relation(:products).by_id(id).one!
        json(products: product)
      rescue ROM::TupleCountMismatchError
        record_not_found(id)
      end
    end

    post '/products' do
      begin
        result = rom.command(:products).try do
          rom.command(:products).create.call(params)
        end
        status 201
        json(products: result.value)
      rescue ValidationError => e
        invalid_params(e.params)
      end
    end

    patch '/products/:id' do |id|
      begin
        product = rom.relation(:products).by_id(id).one!
        attrs = product.merge(params.symbolize_keys)
        result = rom.command(:products).try do
          rom.command(:products).update.by_id(id).set(attrs)
        end
        json(products: result.value)
      rescue ROM::TupleCountMismatchError
        record_not_found(id)
      end
    end

    delete '/products/:id' do |id|
      result = rom.command(:products).try do
        rom.command(:products).delete.by_id(id).call
      end
      result.value ? delete_response : record_not_found(id)
    end
  end
end

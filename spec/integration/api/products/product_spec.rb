require 'spec_helper'

RSpec.describe 'GET /products/:id' do
  include AppSetup

  it_behaves_like "API over HTTPS with Basic Auth" do
    let(:do_request) { product_call }
    let!(:login) { create_user.value }

    context 'missing data' do
      before { product_call(base_params.merge({id: 'foo'})) }

      it 'responds with 404 HTTP code if Record Not Found' do
        expect(last_response.status).to eq(404)
      end
    end

    context 'data exists' do
      before { product_call }

      it 'responds with 200 HTTP code' do
        expect(last_response.status).to eq(200)
      end

      it 'returns JSON' do
        expect(last_response.headers['Content-Type']).to match 'application/json'
      end

      it 'returns JSON formatted product' do
        res = json_response

        expect(res).to be_a(Hash)
        expect(res).to have_key('products')
        expect(res['products']).to be_a(Hash)
        expect(res['products']['name']).to eq('Foo')
      end
    end
  end

  private
  def product_call(params=base_params)
    get "/products/#{params[:id]}", params, base_env
  end

  def base_params
    {
      id: create_product.value[:id],
      access_token: login[:token]
    }
  end
end

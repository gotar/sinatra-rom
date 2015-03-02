require 'spec_helper'

RSpec.describe 'POST /products' do
  include AppSetup

  it_behaves_like "API over HTTPS with Basic Auth" do
    let(:do_request){ create_product_call }
    let!(:login) { create_user.value }

    context 'invalid params' do
      let(:do_request){ create_product_call(name: nil) }
      before { create_product_call(name: nil) }

      it 'returns 422 HTTP error for invalid params' do
        expect(last_response.status).to eq(422)
      end

      it 'returs JSON' do
        expect(last_response.headers['Content-Type']).to match 'application/json'
      end

      it 'returns JSON formatted message' do
        expect(json_response).to eq({'code' => 422, 'message' => 'Invalid data for fields: name'})
      end
    end

    context 'valid params' do
      before { create_product_call }

      it 'responds with 201 HTTP code' do
        expect(last_response.status).to eq(201)
      end

      it 'returns JSON' do
        expect(last_response.headers['Content-Type']).to match 'application/json'
      end

      it 'returns JSON formatted product' do
        res = json_response

        expect(res).to be_a(Hash)
        expect(res).to have_key('products')
        expect(res['products']).to be_a(Hash)
        expect(res['products']['name']).to eq(base_params[:name])
      end
    end
  end

  private
  def create_product_call(params={})
    post '/products', base_params.merge(params), base_env
  end

  def base_params
    {
      name: 'Foo',
      access_token: login[:token]
    }
  end
end

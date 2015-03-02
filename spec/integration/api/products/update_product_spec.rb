require 'spec_helper'

RSpec.describe 'PATCH /products/:id' do
  include AppSetup

  it_behaves_like "API over HTTPS with Basic Auth" do
    let(:do_request){ update_product_call }
    let!(:login) { create_user.value }

    context 'missing record' do
      before { update_product_call(id: 'foo') }

      it 'returns 404 HTTP error if record not found' do
        expect(last_response.status).to eq(404)
      end

      it 'returs JSON' do
        expect(last_response.headers['Content-Type']).to match 'application/json'
      end

      it 'returns JSON formatted message' do
        expect(json_response).to eq({'code' => 404, 'message' => 'Record Not Found for given [:id] => foo'})
      end
    end

    context 'existing record' do
      before do
        id = create_product.value[:id]
        update_product_call(id: id, name: 'BOO')
      end

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
        expect(res['products']['name']).to eq('BOO')
      end
    end
  end

  private
  def update_product_call(params={})
    patch "/products/#{params[:id]}", base_params.merge(params), base_env
  end

  def base_params
    {
      access_token: login[:token]
    }
  end
end

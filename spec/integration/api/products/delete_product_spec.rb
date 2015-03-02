require 'spec_helper'

RSpec.describe 'DELETE /products/:id' do
  include AppSetup

  it_behaves_like "API over HTTPS with Basic Auth" do
    let(:do_request){ delete_product_call }
    let!(:login) { create_user.value }

    context 'missing record' do
      before { delete_product_call(id: 'foo') }

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
        delete_product_call(id: id)
      end

      it 'responds with 204 HTTP code' do
        expect(last_response.status).to eq(204)
      end

      it 'returns no response' do
        expect(last_response.body).to be_empty
      end
    end
  end

  private
  def delete_product_call(params={})
    delete "/products/#{params[:id]}", base_params.merge(params), base_env
  end

  def base_params
    {
      access_token: login[:token]
    }
  end
end

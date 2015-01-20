require 'spec_helper'

RSpec.describe 'GET /products' do
  include AppSetup

  it_behaves_like "API over HTTPS with Basic Auth" do
    let(:do_request) { products_call }

    before { products_call }

    it 'responds with 200 HTTP code' do
      expect(last_response.status).to eq(200)
    end

    it 'returns JSON' do
      expect(last_response.headers['Content-Type']).to match 'application/json'
    end

    it 'returns JSON formatted products' do
      res = json_response

      expect(res).to be_a(Hash)
      expect(res).to have_key('products')
      expect(res['products']).to be_an(Array)
      expect(res['products']).to be_empty
    end
  end

  private
  def products_call(params={})
    get '/products', params, base_env
  end
end

require 'spec_helper'

RSpec.describe 'GET /products' do
  include AppSetup

  it_behaves_like "API over HTTPS with Basic Auth" do
    let(:do_request) { products_call }
    let!(:login) { create_user.value }

    it 'responds with 200 HTTP code' do
      do_request
      expect(last_response.status).to eq(200)
    end

    it 'returns JSON' do
      do_request
      expect(last_response.headers['Content-Type']).to match 'application/json'
    end

    context 'existing records' do
      before { 10.times { create_product } }

      it 'returns JSON formatted products' do
        do_request

        res = json_response
        expect(res).to be_a(Hash)
        expect(res).to have_key('products')
        expect(res['products']).to be_an(Array)
        expect(res['products'].size).to eq(10)
      end

      context 'pagination' do
        context 'invalid params' do
          it 'throw error for page < 1' do
            products_call(per_page: 5, page: 0)

            expect(last_response.status).to eq(422)
          end

          it 'throw error for per_page < 1' do
            products_call(per_page: 0, page: 1)

            expect(last_response.status).to eq(422)
          end

          it 'throw error for per_page > 100' do
            products_call(per_page: 101, page: 0)

            expect(last_response.status).to eq(422)
          end
        end

        context 'valid params' do
          before{ products_call(per_page: 5, page: 2) }

          it 'allows to limit results' do
            expect(json_response['products'].size).to eq(5)
          end

          it 'returns proper data' do
            expect(json_response['products'].map{|x| x['id']}).to eq([6,7,8,9,10])
          end
        end
      end
    end
  end

  private
  def products_call(params={})
    get '/products', base_params.merge(params), base_env
  end

  def base_params
    {
      access_token: login[:token]
    }
  end
end

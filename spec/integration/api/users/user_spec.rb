require 'spec_helper'

RSpec.describe 'GET /users/:id' do
  include AppSetup

  it_behaves_like "API over HTTPS with Basic Auth" do
    let(:do_request) { user_call(base_params) }

    context 'missing data' do
      before { user_call({id: 'foo'}) }

      it 'responds with 404 HTTP code if Record Not Found' do
        expect(last_response.status).to eq(404)
      end
    end

    context 'data exists' do
      before { user_call(base_params) }

      it 'responds with 200 HTTP code' do
        expect(last_response.status).to eq(200)
      end

      it 'returns JSON' do
        expect(last_response.headers['Content-Type']).to match 'application/json'
      end

      it 'returns JSON formatted user' do
        res = json_response

        expect(res).to be_a(Hash)
        expect(res).to have_key('users')
        expect(res['users']).to be_a(Hash)
        expect(res['users']['email']).to eq('example@example.com')
      end
    end
  end

  private
  def user_call(params={})
    get "/users/#{params[:id]}", params, base_env
  end

  def base_params
    {
      id: create_user.value[:id]
    }
  end
end

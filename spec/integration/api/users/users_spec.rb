require 'spec_helper'

RSpec.describe 'GET /users' do
  include AppSetup

  it_behaves_like "API over HTTPS with Basic Auth" do
    let(:do_request) { users_call }

    before { users_call }

    it 'responds with 200 HTTP code' do
      expect(last_response.status).to eq(200)
    end

    it 'returns JSON' do
      expect(last_response.headers['Content-Type']).to match 'application/json'
    end

    it 'returns JSON formatted users' do
      res = json_response

      expect(res).to be_a(Hash)
      expect(res).to have_key('users')
      expect(res['users']).to be_an(Array)
      expect(res['users']).to be_empty
    end
  end

  private
  def users_call(params={})
    get '/users', params, base_env
  end
end

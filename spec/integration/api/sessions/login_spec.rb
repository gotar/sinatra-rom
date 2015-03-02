require 'spec_helper'

RSpec.describe 'GET /login' do
  include AppSetup
  let!(:user) { create_user.value }

  it_behaves_like "API over HTTPS with Basic Auth" do
    let(:do_request) { login_call }

    context 'missing data' do
      before { login_call({email: 'foo@example.com'}) }

      it 'responds with 404 HTTP code if Record Not Found' do
        expect(last_response.status).to eq(404)
      end

      it 'returns JSON formated error message' do
        expect(json_response['message']).to eq('Record Not Found for given [:email, :password] => ["foo@example.com", "password"]')
      end
    end

    context 'data exists' do
      context 'missing params' do
        before { login_call({email: nil, password: nil}) }

        it 'responds with 422 HTTP code ' do
          expect(last_response.status).to eq(422)
        end

        it 'returns JSON' do
          expect(last_response.headers['Content-Type']).to match 'application/json'
        end

        it 'returns JSON formatted error' do
          res = json_response

          expect(res).to be_a(Hash)
          expect(res['message']).to eq("Invalid data for fields: email, password")
        end

      end

      context 'invalid password' do
        before { login_call(password: 'foobar123') }

        it 'responds with 401 HTTP code ' do
          expect(last_response.status).to eq(401)
        end

        it 'returns JSON' do
          expect(last_response.headers['Content-Type']).to match 'application/json'
        end

        it 'returns JSON formatted error' do
          res = json_response

          expect(res).to be_a(Hash)
          expect(res['message']).to eq("Invalid password for user: #{base_params[:email]}")
        end
      end

      context 'valid password' do
        before { login_call }

        it 'responds with 200 HTTP code ' do
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
          expect(res['users']['access_token']).to eq(user[:token])
        end
      end
    end
  end

  private
  def login_call(params={})
    get "/login", base_params.merge(params), base_env
  end

  def base_params
    {
      email: user[:email],
      password: 'password'
    }
  end
end


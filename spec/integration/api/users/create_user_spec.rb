require 'spec_helper'

RSpec.describe 'POST /users' do
  include AppSetup

  it_behaves_like "API over HTTPS with Basic Auth" do
    let(:do_request){ create_user_call }

    context 'invalid params' do
      let(:do_request){ create_user_call(email: nil) }
      before { create_user_call(email: nil) }

      it 'returns 422 HTTP error for invalid params' do
        expect(last_response.status).to eq(422)
      end

      it 'returs JSON' do
        expect(last_response.headers['Content-Type']).to match 'application/json'
      end

      it 'returns JSON formatted message' do
        expect(json_response).to eq({'code' => 422, 'message' => 'Invalid data for fields: email'})
      end
    end

    context 'valid params' do
      before { create_user_call }

      it 'responds with 201 HTTP code' do
        expect(last_response.status).to eq(201)
      end

      it 'returns JSON' do
        expect(last_response.headers['Content-Type']).to match 'application/json'
      end

      it 'returns JSON formatted product' do
        res = json_response

        expect(res).to be_a(Hash)
        expect(res).to have_key('users')
        expect(res['users']).to be_a(Hash)
        expect(res['users']['email']).to eq(base_params[:email])
        expect(res['users']['token']).to_not be_nil
      end
    end
  end

  private
  def create_user_call(params={})
    post '/users', base_params.merge(params), base_env
  end

  def base_params
    {
      email: 'example@example.com',
      password: 'password'
    }
  end
end

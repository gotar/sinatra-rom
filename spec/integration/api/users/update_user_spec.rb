require 'spec_helper'

RSpec.describe 'PATCH /users/:id' do
  include AppSetup

  it_behaves_like "API over HTTPS with Basic Auth" do
    let(:do_request){ update_user_call }
    let!(:login) { create_user.value }

    context 'missing record' do
      before { update_user_call(id: 'foo') }

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
      let!(:user) { create_user.value }

      before do
        id = user[:id]
        update_user_call(id: id, email: 'new@example.com')
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
        expect(res).to have_key('users')
        expect(res['users']).to be_a(Hash)
        expect(res['users']['email']).to eq('new@example.com')
      end

      it 'does\'t change password_hash after update if password was not given' do
        expect(json_response['users']['password_hash']).to eq(user[:password_hash])
      end

      it 'does\'t change token after update' do
        expect(json_response['users']['token']).to eq(user[:token])
      end
    end

    it 'do not allow for password shorter then 8 charts' do
      user = create_user.value

      update_user_call(id: user[:id], password: 'foo')

      expect(last_response.status).to eq(422)
      expect(json_response['message']).to eq('Invalid data for fields: password')

    end

    it 'returns error is users with given email already exists' do
      user1 = create_user.value
      user2 = create_user.value

      update_user_call(id: user1[:id], email: user2[:email])

      expect(last_response.status).to eq(422)
      expect(json_response['message']).to eq('SQLite3::ConstraintException: UNIQUE constraint failed: users.email')
    end
  end

  private
  def update_user_call(params={})
    patch "/users/#{params[:id]}", base_params.merge(params), base_env
  end

  def base_params
    {
      access_token: login[:token]
    }
  end
end

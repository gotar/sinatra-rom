require 'spec_helper'

RSpec.describe 'PATCH /users/:id' do
  include AppSetup

  it_behaves_like "API over HTTPS with Basic Auth" do
    let(:do_request){ update_user_call }

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
      let(:user) { create_user.value }

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

      it 'does\'t change token after update' do
        expect(json_response['users']['token']).to eq(user[:token])
      end
    end
  end

  private
  def update_user_call(params={})
    patch "/users/#{params[:id]}", params, base_env
  end
end

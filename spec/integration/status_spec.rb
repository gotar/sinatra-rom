require 'spec_helper'

RSpec.describe 'Status Requests' do
  include AppSetup

  describe 'GET /status' do
    before { do_request }

    it 'responds with 200 HTTP code' do
      expect(last_response.status).to eq(200)
    end

    it 'returns proper message' do
      expect(last_response.body).to eq('OK')
    end
  end

  private
  def do_request
    get '/status'
  end
end

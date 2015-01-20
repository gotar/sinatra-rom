shared_examples_for "API over HTTPS with Basic Auth" do
  let(:base_env) { {'HTTPS' => 'on'} }

  before do
    authorize api_username, api_password
  end

  context "with https enabled" do
    it "rejects request without http basic credentials" do
      header('Authorization', nil)

      do_request

      expect(last_response.status).to eq(401)
      expect(last_response.body).to be_blank
    end

    it "rejects request with bad http basic credentials" do
      authorize 'black', 'hat'

      do_request

      expect(last_response.status).to eq(401)
      expect(last_response.body).to be_blank
    end
  end

  context "without https enabled" do
    let(:base_env) { {} }

    it "rejects non-https requests" do
      do_request

      expect(last_response.status).to eq(403)
      expect(last_response.body).to be_blank
    end
  end
end

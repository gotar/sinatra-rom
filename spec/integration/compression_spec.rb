require 'spec_helper'

describe 'Compression' do
  include AppSetup

  context 'a visitor has a browser that supports compression' do
    ['deflate','gzip', 'deflate,gzip','gzip,deflate'].each do |compression_method|
      it "Content-Encoding header for #{compression_method} should not be nil" do
        get '/', {}, {'HTTP_ACCEPT_ENCODING' => compression_method}

        expect(last_response.header['Content-Encoding']).to_not be_nil
      end
    end
  end

  context 'a visitor\'s browser does not support compression' do
    it 'Content-Encoding header should be nil' do
      get '/'

      expect(last_response.header['Content-Encoding']).to be_nil
    end
  end
end

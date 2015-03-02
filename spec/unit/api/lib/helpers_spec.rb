require_relative '../../../../lib/helpers'

describe API::Helpers do
  include API::Helpers

  describe 'convert_time' do
    let!(:t) { Time.now }

    it 'converts Time to ISO 8601 format' do
      expect(convert_time(t)).not_to eq(t)
      expect(convert_time(t)).to eq(t.iso8601)
    end

    it 'converts Time expressed as String to ISO 8601 format' do
      expect(convert_time(t.to_s)).not_to eq(t)
      expect(convert_time(t.to_s)).not_to eq(t.to_s)
      expect(convert_time(t.to_s)).to eq(t.iso8601)
    end

    it 'do nothing if String cannot be parse as Time' do
      expect(convert_time('foo')).to eq('foo')
    end

    it 'do nothing if its not Time or String' do
      expect(convert_time(nil)).to be_nil
    end
  end
end

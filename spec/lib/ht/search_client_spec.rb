require 'spec_helper'

describe Ht::SearchClient do
  describe '#configure' do
    before do
      described_class.configure do |config|
        config.url = 'search-service.com'
      end
    end

    it 'uses the set configuration' do
      expect(described_class.configuration.url).to eql 'search-service.com'
    end
  end
end

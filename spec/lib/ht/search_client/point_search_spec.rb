require 'spec_helper'

describe Ht::SearchClient::PointSearch do
  using Ht::SearchClient::Test

  let(:options) { { latitude: 51.49, longitude: -0.13, radius: 50 } }
  subject       { described_class.new(options) }

  describe '#perform' do
    before do
      Ht::SearchClient::PointSearch
        .stub_request(options)
        .with_results(properties: [
          { 'property_id' => 123, 'average_price' => 12.32 },
        ])

      subject.perform
    end

    it 'returns the matching property' do
      expect(subject.results).to eql [
        { 'property_id' => 123, 'average_price' => 12.32 }
      ]
    end
  end
end

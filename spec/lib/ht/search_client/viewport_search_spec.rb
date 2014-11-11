require 'spec_helper'

describe Ht::SearchClient::ViewportSearch do
  using Ht::SearchClient::Test

  let(:options) do
    {
      bottom_left_lat: 52.33,
      bottom_left_lon: 13.08,
      top_right_lat: 52.67,
      top_right_lon: 13.76
    }
  end
  subject { described_class.new(options) }

  describe '#perform' do
    before do
      Ht::SearchClient::ViewportSearch
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

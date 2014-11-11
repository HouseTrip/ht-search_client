require 'spec_helper'

describe Ht::SearchClient::PlaceSearch do
  using Ht::SearchClient::Test

  let(:options) { { foo: 'bar', place_id: 1234 } }
  subject       { described_class.new(options) }

  describe '#perform' do
    before do
      Ht::SearchClient::PlaceSearch
        .stub_request(options)
        .with_results(properties: [
          { 'property_id' => 123, 'average_price' => 123.12 },
          { 'property_id' => 121, 'average_price' => 121.21 },
        ])

      subject.perform
    end

    it 'returns the matching property ids in the correct order' do
      expect(subject.results).to eql [
        { 'property_id' => 123, 'average_price' => 123.12 },
        { 'property_id' => 121, 'average_price' => 121.21 }
      ]
    end
  end
end

require 'spec_helper'

describe Ht::SearchClient::PropertyIdsStaySearch do
  using Ht::SearchClient::Test

  let(:options) { { property_ids: [121, 122], from: '2020-08-15', to: '2020-08-20' } }
  subject       { described_class.new(options) }
  let(:results) { subject.perform; subject.results }

  describe '#perform' do
    before do
      Ht::SearchClient::PropertyIdsStaySearch
        .stub_post_request(options)
        .with_results(properties: [
          { 'property_id' => 121, 'average_price' => 121.21 },
          { 'property_id' => 122, 'average_price' => 321.09 }
        ])
    end

    it 'returns the matching property ids in the correct order' do
      expect(results).to eql [
        {
          'property_id' => 121,
          'stay_cost' => 1880.0,
          'total_commission' => 280.0,
          'commission_tax' => 0.0,
          'commission' => 280.0,
          'days_cost' => 1600.0,
          'extra_guest_price' => 0.0,
          'long_stay_discount' => 0.0
        },
        {
          'property_id' => 122,
          'stay_cost' => 1880.0,
          'total_commission' => 280.0,
          'commission_tax' => 0.0,
          'commission' => 280.0,
          'days_cost' => 1600.0,
          'extra_guest_price' => 0.0,
          'long_stay_discount' => 0.0
        }
      ]
    end

    it 'should raise error without property ids' do
      options.delete(:property_ids)
      expect { subject.perform }.to raise_error(KeyError)
    end

    it 'should raise error without stay details' do
      options.delete(:from)
      expect { subject.perform }.to raise_error(KeyError)
    end

  end
end

require 'spec_helper'

describe Ht::SearchClient::PlaceStaySearch do
  describe '#perform' do
    let(:options) do
      {
        foo: 'bar',
        place_id: 1234,
        from: Date.parse('2014-10-10'),
        to: Date.parse('2014-10-15')
      }
    end

    let(:results) do
      [
        {
          'property_id'        => 10,
          'stay_cost'          => 1880.0,
          'total_commission'   => 280.0,
          'commission_tax'     => 0.0,
          'commission'         => 280.0,
          'days_cost'          => 1600.0,
          'extra_guest_price'  => 0.0,
          'long_stay_discount' => 0.0
        }
      ]
    end

    subject { described_class.new(options) }

    it_should_behave_like 'a stay search' do
      context 'when one of the required place search params is missing' do
        before { options.delete(:place_id) }

        it 'should raise error' do
          expect { subject.perform }.to raise_error(KeyError)
        end
      end
    end
  end
end

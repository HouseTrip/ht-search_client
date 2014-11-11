require 'spec_helper'

describe Ht::SearchClient::Test do

  context 'when dateless search' do

    let(:params) { { place_id: 10 } }

    it 'raises a webmock error' do
      expect { Ht::SearchClient::PlaceSearch.new(params).perform }.to raise_error(WebMock::NetConnectNotAllowedError)
    end

    context 'when refinement is applied' do
      using described_class

      subject       { Ht::SearchClient::PlaceSearch.new(params).perform }
      let(:results) { subject['results'] }

      context 'when using defaults' do
        before do
          Ht::SearchClient::PlaceSearch
           .stub_request(params)
           .with_results(properties: [
             { 'property_id' => 10 }
           ])
        end

        it 'does not raise a webmock error' do
          expect { subject }.to_not raise_error
        end

        it 'expects a specific default struture' do
          expect(subject).to eql({
            'page'     => 1,
            'per_page' => 32,
            'total'    => 1,
            'results'  => [
              { 'property_id' => 10, 'average_price' => 100 }
            ]})
        end
      end

      context 'when overriding defaults' do
        before do
          Ht::SearchClient::PlaceSearch
           .stub_request(params)
           .with_results(properties: [
             { 'property_id' => 10, 'average_price' => 200, 'distance' => 20 }
           ])
        end

        it 'expects a specific overriden struture' do
          expect(subject).to eql({
            'page'     => 1,
            'per_page' => 32,
            'total'    => 1,
            'results'  => [
              {
                'property_id'   => 10,
                'average_price' => 200,
                'distance'      => 20
              }
            ]})
        end

      end

    end

  end

  context 'when dated search' do

    let(:params) do
      {
        place_id: 10,
        from:     '2024-10-20',
        to:       '2024-10-25'
      }
    end

    it 'raises a webmock error' do
      expect { Ht::SearchClient::PlaceStaySearch.new(params).perform }.to raise_error(WebMock::NetConnectNotAllowedError)
    end

    context 'when refinement is applied' do
      using described_class

      subject       { Ht::SearchClient::PlaceStaySearch.new(params).perform }
      let(:results) { subject['results'] }

      context 'when using defaults' do
        before do
          Ht::SearchClient::PlaceStaySearch
           .stub_request(params)
           .with_results(properties: [
             { 'property_id' => 10 }
           ])
        end

        it 'expects a specific default struture' do
          expect(subject).to eql({
            'page'     => 1,
            'per_page' => 32,
            'total'    => 1,
            'results'  => [
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
          })
        end
      end

      context 'when overriding defaults' do
        before do
          Ht::SearchClient::PlaceStaySearch
           .stub_request(params)
           .with_results(properties: [
             {
                'property_id'        => 10,
                'stay_cost'          => 200.0,
                'total_commission'   => 100.0,
                'commission_tax'     => 0.0,
                'commission'         => 300.0,
                'days_cost'          => 800.0,
                'extra_guest_price'  => 0.0,
                'long_stay_discount' => 0.0
             }
           ])
        end

        it 'expects a an overriden struture' do
          expect(subject).to eql({
            'page'     => 1,
            'per_page' => 32,
            'total'    => 1,
            'results'  => [
              {
                'property_id'        => 10,
                'stay_cost'          => 200.0,
                'total_commission'   => 100.0,
                'commission_tax'     => 0.0,
                'commission'         => 300.0,
                'days_cost'          => 800.0,
                'extra_guest_price'  => 0.0,
                'long_stay_discount' => 0.0
              }
            ]
          })
        end
      end

    end

  end
end

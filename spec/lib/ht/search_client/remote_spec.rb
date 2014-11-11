require 'spec_helper'

describe Ht::SearchClient::Remote do
  describe 'a subclass' do
    let(:params)    { { destination_id: 1234 } }
    let(:subsearch) {
      Class.new(described_class) do
        def endpoint
          '/foo'
        end
      end
    }
    let(:request_url) { 'http://username:password@test.com/foo?per_page=32&page=1&currency=EUR&order=sqs_score' }

    subject { subsearch.new(params) }

    before do
      stub_request(:get, request_url).
        to_return(status: 200, body: body.to_json)
    end

    describe '#perform' do
      let(:expected_values) do
        [
          {'property_id' => 1, 'average_price' => 11.11},
          {'property_id' => 2, 'average_price' => 22.22},
          {'property_id' => 3, 'average_price' => 33.33}
        ]
      end

      let(:body) { { results: expected_values } }

      context 'the request is sucessful' do

        it 'should return the correct ids' do
          expect(subject.results).to eql expected_values
        end

        context 'and a block is passed in' do
          it 'uses the block' do
            subject.perform do |response|
              expect(response['results']).to eql expected_values
            end
          end
        end
      end

      context 'there are extra parameters' do
        let(:params) { { bedrooms: 2 } }
        let(:request_url) { 'http://username:password@test.com/foo?bedrooms=2&per_page=32&page=1&currency=EUR&order=sqs_score' }

        it 'should add the parameters to the query' do
          subject.perform
          expect(stub_request :get, request_url).to have_been_requested
        end
      end

      context 'when currency is different' do
        let(:params)      { { currency: 'USD' } }
        let(:request_url) { 'http://username:password@test.com/foo?per_page=32&page=1&currency=USD&order=sqs_score' }

        it 'should add the parameter to the query' do
          subject.perform
          expect(stub_request :get, request_url).to have_been_requested
        end
      end
    end

    describe 'result attributes accessors' do
      let(:body) do
        {
          'results' => [
            {'property_id' => 1, 'average_price' => 11.11, '_links' => { 'property' => 'internal_api_property_url_1' }},
            {'property_id' => 2, 'average_price' => 22.22, '_links' => { 'property' => 'internal_api_property_url_2' }},
            {'property_id' => 3, 'average_price' => 33.33, '_links' => { 'property' => 'internal_api_property_url_3' }}
          ],
          'total' => 800,
          'page' => 2,
          'per_page' => 3,
        }
      end

      describe '#results' do
        it 'returns the result ids and prices' do
          expect(subject.results).to eql([
            {'property_id' => 1, 'average_price' => 11.11, '_links' => {'property' => 'internal_api_property_url_1'}},
            {'property_id' => 2, 'average_price' => 22.22, '_links' => {'property' => 'internal_api_property_url_2'}},
            {'property_id' => 3, 'average_price' => 33.33, '_links' => {'property' => 'internal_api_property_url_3'}}
          ])
        end
      end

      describe '#total' do
        it 'returns the total number of results from the search' do
          expect(subject.total).to eql(800)
        end
      end

      describe '#per_page' do
        it 'returns the per page of the search' do
          expect(subject.per_page).to eql(3)
        end
      end

      describe '#page' do
        it 'returns the current page number' do
          expect(subject.page).to eql(2)
        end
      end
    end
  end
end

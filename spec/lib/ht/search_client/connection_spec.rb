require 'spec_helper'

describe Ht::SearchClient::Connection do
  let(:request_url) { 'http://username:password@test.com/foo' }
  let(:monitor) { Ht::SearchClient.monitor }

  describe '#get' do
    let(:perform) { subject.get(request_url, {}) }

    context 'the request is successful' do
      before do
        stub_request(:get, request_url).
          to_return(status: 200, body: { results: [1, 2, 3] }.to_json, headers: {})
      end

      it 'notifies the monitor class of the search' do
        expect(monitor).to receive(:notify).with('attempts').ordered
        expect(monitor).to receive(:notify).with('success').ordered

        perform
      end
    end

    context 'the request times out' do
      let(:error_class) { Faraday::Error::TimeoutError }
      let(:response) { nil }

      before do
        stub_request(:get, request_url).
          to_timeout
      end

      it_should_behave_like 'error handling'
    end

    context 'the request fails' do
      before do
        stub_request(:get, request_url).
          to_return(response.merge! headers: {})
      end

      context 'because of invalid JSON' do
        let(:error_class) { JSON::ParserError }
        let(:response) { { status: 200, body: 'bad json: ]' } }

        it_should_behave_like 'error handling'
      end

      context 'because of bad request' do
        let(:error_class) { Ht::SearchClient::Connection::BadRequestError }
        let(:response) { { status: 400, body: 'Bad arguments' } }

        it_should_behave_like 'error handling'
      end

      context 'because the request is not authorised' do
        let(:error_class) { Ht::SearchClient::Connection::AuthenticationError }
        let(:response) { { status: 402, body: 'Unauthorised' } }

        it_should_behave_like 'error handling'
      end

      context 'because of internal server error' do
        let(:error_class) { Ht::SearchClient::Connection::InternalServerError }
        let(:response) { { status: 500, body: 'Internal error' } }

        it_should_behave_like 'error handling'
      end

      context 'because of service unavailable error' do
        let(:error_class) { Ht::SearchClient::Connection::ServiceUnavailableError }
        let(:response) { { status: 503, body: 'Service Unavailable' } }

        it_should_behave_like 'error handling'
      end

      context 'because of unknown error' do
        let(:error_class) { Ht::SearchClient::Connection::UnknownServerError }
        let(:response) { { status: 406, body: 'Oh, crap' } }

        it_should_behave_like 'error handling'
      end
    end
  end
end

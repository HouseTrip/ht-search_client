require 'faraday'

module Ht::SearchClient
  class Connection
    class BadRequestError < StandardError; end
    class AuthenticationError < StandardError; end
    class InternalServerError < StandardError; end
    class ServiceUnavailableError < StandardError; end
    class UnknownServerError < StandardError; end

    def get(path, params)
      monitor.notify('attempts')

      with_error_handling(path, params) do
        @response = client.get(path, params)
        assert_valid_response
      end
    end

    private

    def monitor
      Ht::SearchClient.monitor
    end

    def exception_handler
      Ht::SearchClient.exception_handler
    end

    def client
      Faraday.new(url: service_url) do |conn|
        conn.request    :url_encoded
        conn.adapter    Faraday.default_adapter
        conn.basic_auth username, password
        conn.options[:timeout] = 10
        conn.headers['Accept'] = "application/hal+json;v=#{API_VERSION}"
      end
    end

    def assert_valid_response
      if @response.success?
        parsed_body = parse_body
        monitor.notify('success')

        return parsed_body
      end

      case @response.status
      when 400
        raise BadRequestError
      when 402
        raise AuthenticationError
      when 500
        raise InternalServerError
      when 503
        raise ServiceUnavailableError
      else
        raise UnknownServerError
      end
    end

    def with_error_handling(path, params)
      yield
    rescue => exception
      monitor.notify('errors')

      exception_handler.notify(exception, params.merge(path: path), @response)
    end

    def parse_body
      JSON.parse(@response.body)
    end

    def service_url
      Ht::SearchClient.configuration.url
    end

    def username
      Ht::SearchClient.configuration.username
    end

    def password
      Ht::SearchClient.configuration.password
    end
  end
end

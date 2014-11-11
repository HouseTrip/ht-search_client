module Ht::SearchClient
  class StandardExceptionHandler
    def notify(exception, params, response)
      message = "#{exception.class.to_s}, raw_parameters: #{params.inspect}"

      if response
        message << ",\n"
        message << "response_code: #{response.status},\n"
        message << "response_body: #{response.body}"
      end

      $stderr.puts message if Ht::SearchClient.configuration.verbose

      raise exception
    end
  end
end

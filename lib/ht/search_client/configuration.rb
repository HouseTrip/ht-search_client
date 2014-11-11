module Ht::SearchClient
  class Configuration
    class MissingConfigurationError < StandardError; end

    attr_writer :url, :username, :password
    attr_accessor :monitor_class, :exception_handler_class, :verbose

    def initialize
      @monitor_class = Ht::SearchClient::StandardMonitor
      @exception_handler_class = Ht::SearchClient::StandardExceptionHandler
      @verbose = false
    end

    def url
      assert_present('url', @url)
    end

    def username
      assert_present('username', @username)
    end

    def password
      assert_present('password', @password)
    end

    private

    def assert_present(config_name, config_value)
      raise MissingConfigurationError, "You must specify #{config_name}" unless config_value

      config_value
    end
  end
end

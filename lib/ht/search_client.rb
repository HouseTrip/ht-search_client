require 'ht/search_client/version'
require 'ht/search_client/connection'
require 'ht/search_client/remote'
require 'ht/search_client/test'
require 'ht/search_client/stay_search'
require 'ht/search_client/place_search'
require 'ht/search_client/point_search'
require 'ht/search_client/viewport_search'
require 'ht/search_client/place_stay_search'
require 'ht/search_client/point_stay_search'
require 'ht/search_client/property_ids_stay_search'
require 'ht/search_client/viewport_stay_search'
require 'ht/search_client/configuration'
require 'ht/search_client/standard_monitor'
require 'ht/search_client/standard_exception_handler'

module Ht
  module SearchClient
    API_VERSION = 1

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.monitor
      @monitor ||= configuration.monitor_class.new
    end

    def self.exception_handler
      @exception_handler ||= configuration.exception_handler_class.new
    end

    def self.configure
      yield(configuration)
    end
  end
end

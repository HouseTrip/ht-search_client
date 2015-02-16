require 'json'

module Ht::SearchClient
  # Abstract class for every remote property search using Search Service
  #
  # Define your own kind of search by inheriting from this class and defining
  # an #endpoint and #params methods
  #
  class Remote
    ALLOWED_PARAMS = [
      :order, :per_page, :types, :features,
      :bedrooms, :page, :guests, :price_min,
      :price_max, :currency, :aggregations, :range_aggregations,
      :excluding_ids, :random, :random_order_seed
    ].freeze

    def initialize(raw_params = {})
      @raw_params = raw_params.tap do |params|
        params[:excluding_ids] = params[:excluding_ids].join(',') if params.has_key?(:excluding_ids)
      end
    end

    def perform
      return search unless block_given?
      yield search
    end

    def results
      search.fetch 'results'
    end

    def total
      search.fetch 'total'
    end

    def per_page
      search.fetch 'per_page'
    end

    def page
      search.fetch 'page'
    end

    def aggregations
      search.fetch('aggregations') { nil }
    end

    def params
      @params ||= default_options.merge(search_options).freeze
    end

    def method
      :get
    end

    protected

    attr_reader :raw_params

    def search
      @search ||= connection.public_send(method, endpoint, params)
    end

    def default_options
      {
        per_page: 32,
        page:     1,
        currency: 'EUR',
        order:    'sqs_score'
      }
    end


    # NOTE: Developer Sanity announcement this method is
    # being overriden by StaySearch
    def allowed_params
      ALLOWED_PARAMS
    end

    def search_options
      raw_params.select { |key, value| allowed_params.include? key.to_sym }
    end

    private

    def connection
      Ht::SearchClient::Connection.new
    end
  end
end

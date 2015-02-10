module Ht::SearchClient
  #
  # POST /properties/stays
  # POST body
  #   {
  #     from: '2050-01-01',
  #     to: '2050-01-01',
  #     property_ids: '1,2,3,4',
  #     order: 'sqs_score',
  #     etc.
  #   }
  #
  # For a given place and dates, return matching stays
  #
  # Parameters:
  #   Required:
  #     - :property_ids - array of properties ids
  #     - :from - the check-in date
  #     - :to - the check-out date
  #   Optional:
  #     - :order - order by
  #     - :per_page - max number of stays in response
  #     - :page - page of response
  #     - :types - type of properties we search for
  #     - :features - list of required features ( pets / child friendly )
  #     - :guests - number of minimum guests
  #     - :bedrooms - number of minimum bedrooms
  #     - :price_min - minimum price per night
  #     - :price_max - maximum price per night
  #     - :currency - currency code (required when using price-min and/or price-max)
  #
  # Response:
  #   - An array of stays data and pagination details
  #   {
  #     'total'    => 120,
  #     'per_page' => 32,
  #     'page'     => 1,
  #     'results'  => [
  #       {
  #         'property_id'        => 123,
  #         'stay_cost'          => 1880.0,
  #         'total_commission'   => 280.0,
  #         'commission_tax'     => 0.0,
  #         'commission'         => 280.0,
  #         'days_cost'          => 1600.0,
  #         'extra_guest_price'  => 0.0,
  #         'long_stay_discount' => 0.0
  #       },
  #       {
  #         'property_id'        => 124,
  #         'stay_cost'          => 1880.0,
  #         'total_commission'   => 280.0,
  #         'commission_tax'     => 0.0,
  #         'commission'         => 280.0,
  #         'days_cost'          => 1600.0,
  #         'extra_guest_price'  => 0.0,
  #         'long_stay_discount' => 0.0
  #       },
  #       ...
  #     ]
  #   }
  #
  # Usage:
  #   Instantiate a search with:
  #     - Ht::SearchClient::PropertyIdsStaySearch.new({})
  #   then call #perform on the newly created object
  #   The #perform method is defined in the Remote class
  #
  class PropertyIdsStaySearch < Remote
    include StaySearch

    private

    def endpoint
      'properties/stays'
    end

    def search_options
      super.merge(property_ids: property_ids)
    end

    def allowed_params
      super + [:property_ids]
    end

    def property_ids
      raw_params.fetch(:property_ids).join(',')
    end

    # this endpoint requires a POST request
    def search
      validate_date_params!
      fix_date_format!

      @search ||= connection.post(endpoint, params)
    end
  end
end

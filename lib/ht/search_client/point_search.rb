module Ht::SearchClient
  #
  # GET /point/:lat,:long/properties
  #
  # For a given geo point, return matching properties
  #
  # Parameters:
  #   Required:
  #     - :lat
  #     - :long
  #     - :radius - radius in kilometers
  #   Optional:
  #     - :order - order by
  #     - :per_page - max number of properties in response
  #     - :page - page of response
  #     - :currency - type of currency
  #     - :types - list of searchable property types
  #     - :features - list of required features ( e.g smoking, pets, children )
  #     - :guests - minimum number of guests
  #     - :bedrooms - minimum number of bedrooms
  #     - :price_min - minimum average price per night (currently calculated on-the-fly using AVG in SQL)
  #     - :price_max - maximum average price per night (currently calculated on-the-fly using AVG in SQL)
  #
  # Response:
  #   - An array of properties
  #
  # Usage:
  #   Instantiate a search with:
  #     - Ht::SearchClient::PointSearch.new({})
  #   then call #perform on the newly created object
  #   The #perform method is defined in the Remote class
  #
  class PointSearch < Remote
    private

    def endpoint
      "point/#{latitude},#{longitude}/properties"
    end

    def search_options
      super.merge(radius: radius)
    end

    def latitude
      raw_params.fetch :latitude
    end

    def longitude
      raw_params.fetch :longitude
    end

    def radius
      raw_params.fetch :radius
    end
  end
end

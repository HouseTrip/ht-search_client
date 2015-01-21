module Ht::SearchClient
  #
  # GET /places/:id/properties
  #
  # For a given place, return matching properties
  #
  # Parameters:
  #   Required:
  #     - :place_id - id of a place (location, destination, )
  #   Optional:
  #     - :order - order by
  #     - :per_page - max number of properties in response
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
  #   - An array of properties and pagination details
  #
  # Usage:
  #   Instantiate a search with:
  #     - Ht::SearchClient::PlaceSearch.new({})
  #   then call #perform on the newly created object
  #   The #perform method is defined in the Remote class
  #
  class PlaceSearch < Remote
    private

    def endpoint
      "places/#{place_id}/properties"
    end

    def place_id
      raw_params.fetch :place_id
    end
  end
end

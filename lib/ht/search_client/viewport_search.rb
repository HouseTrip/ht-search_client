module Ht::SearchClient
  #
  # GET viewport/bottom_left_lat,:bottom_left_lon,:top_right_lat,:top_right_lon/properties
  #
  # For a given bounding box, return matching properties
  #
  # Parameters:
  #   Required:
  #     - :bottom_left_lat - the latitude of the bottom-left point
  #     - :bottom_left_lon - the longitude of the bottom-left point
  #     - :top_right_lat - the latitude of the top-right point
  #     - :top_right_lon - the longitude of the top-right point
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
  #     - Ht::SearchClient::ViewportSearch.new(params)
  #   then call #perform on the newly created object
  #   The #perform method is defined in the Remote class
  #
  class ViewportSearch < Remote
    private

    def endpoint
      "viewport/#{points.join(',')}/properties"
    end

    def points
      [
        raw_params.fetch(:bottom_left_lat),
        raw_params.fetch(:bottom_left_lon),
        raw_params.fetch(:top_right_lat),
        raw_params.fetch(:top_right_lon)
      ]
    end
  end
end

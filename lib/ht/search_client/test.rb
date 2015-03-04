module Ht::SearchClient::Test

  refine Ht::SearchClient::Remote.singleton_class do
    def stub_request(params = {})
      new(params).stub_request
    end
  end

  refine Ht::SearchClient::Remote do
    def stub_request
      @webmock = Ht::SearchClient::Connection.stub_request(endpoint, params)
      self
    end

    # Properties must be an hash
    #   You can override the following attributes:
    #   - `id`
    #   - `average_price`
    #   - `distance`
    #
    #   The reason why we don't accept random attributes here NEITHER
    #   we advise stubbing response is because we want our gem to be able
    #   enforce certain param(s) became obsolete. i.e if tomorrow distance
    #   param was renamed, we would like all the tests related to distance
    #   to fail in consumers (if we really have to). This will give confidence
    #   on relying for this gem.
    #
    def with_results(status: 200, properties: [], total: properties.size)
      @webmock.to_return({
        status: status,
        body:   mocked_results(properties, total).to_json
      })
    end

    private

    def stay_class?
      self.class.to_s =~ /Stay/
    end

    def mocked_results(properties, total)
      {
        page:     params.fetch(:page),
        per_page: params.fetch(:per_page),
        total:    total,
        results:  stay_class? ? mocked_stay_properties(properties) : mocked_properties(properties)
      }
    end

    def mocked_properties(properties)
      properties.map do |property|
        {
          'property_id'   => property.fetch('property_id'),
          'average_price' => property.fetch('average_price', 100),
          'distance'      => property.fetch('distance', nil)
        }
        .reject{ |_,v| v.nil? }
      end
    end

    def mocked_stay_properties(properties)
      properties.map do |property|
        {
          'property_id'        => property.fetch('property_id'),
          'stay_cost'          => property.fetch('stay_cost', 1880.0),
          'total_commission'   => property.fetch('total_commission', 280.0),
          'commission_tax'     => property.fetch('commission_tax', 0.0),
          'commission'         => property.fetch('commission', 280.0),
          'days_cost'          => property.fetch('days_cost', 1600.0),
          'extra_guest_price'  => property.fetch('extra_guest_price', 0.0),
          'long_stay_discount' => property.fetch('long_stay_discount', 0.0)
        }
        .reject{ |_,v| v.nil? }
      end
    end
  end

  refine Ht::SearchClient::Connection.singleton_class do
    def stub_request(*args)
      new.stub_request(*args)
    end
  end

  refine Ht::SearchClient::Connection do
    def stub_request(endpoint, params)
      service_uri          = client.build_url(endpoint)
      service_uri.user     = username
      service_uri.password = password

      WebMock.stub_request(:get, service_uri).with(query: params)
    end
  end
end

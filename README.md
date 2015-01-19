# Ht::SearchClient

[![Travis
CI](https://travis-ci.org/HouseTrip/ht-search_client.svg)](http://travis-ci.org/HouseTrip/ht-search_client) [![Dependency
Status](https://gemnasium.com/HouseTrip/ht-search_client.svg)](https://gemnasium.com/HouseTrip/ht-search_client)

A gem client for the [HouseTrip property search service](https://github.com/HouseTrip/property_search).
API documentation is available [here](http://docs.propertysearch.apiary.io/).

Table of contents:

- [Installation](#installation)
- [Configuration](#configuration)
- [Exception Handling](#exception-handling)
- [Monitoring](#monitoring)
- [Usage](#usage)
- [Testing](#testing)

## Installation

Add this line to your application's Gemfile:

    gem 'ht-search_client', git: 'git@github.com:HouseTrip/ht-search_client.git'

## Configuration

The configuration is done by using an initiliazer.

**example config/initializers/search_client.rb:**
```ruby
Ht::SearchClient.configure do |config|
  config.url      = 'SEARCH_SERVICE_HOSTNAME'
  config.username = 'SEARCH_SERVICE_USERNAME'
  config.password = 'SEARCH_SERVICE_PASSWORD'
  config.monitor_class = PropertySearch::Monitor
  config.exception_handler_class = PropertySearch::ExceptionHandler
end
```

## Exception handling

We are leaving the exception handling up to you. You need to define a class that responds to the ```notify``` method. The parameters are:

- **exception** - the exception instance
- **params** - the parameters of the search
- **response** - the Faraday response if there was one

**Example**
```ruby
  class ExceptionHandler
    def notify(exception, params, response)
      # do whatever with the exception
    end
  end
```

## Monitoring

We are leaving the monitoring up to you. We notify you about the following events:

- search attempt
- search success
- search failure

You need to define a class that responds to the ```notify``` method.

**Example**
```ruby
  class Monitor
    def notify(event)
      # event is just a string of the type (attempt, success, failure)
      # do whatever with the event
    end
  end
```

## Usage

So you want to use the Search service? There are few types of search you can perform:

- [PlaceSearch](#placesearch)
- [PlaceStaySearch](#placesearch)
- [PointSearch](#pointsearch)
- [PointStaySearch](#pointsearch)
- [ViewportSearch](#viewportsearch)
- [ViewportStaySearch](#viewportsearch)

You can also pass additional parameters to refine your search:
- [Filter parameters](#filters)
- [Ordering parametrs](#ordering)
- [Pagination parameters](#pagination)

Full documentation available at: [Apiary documentation](http://docs.propertysearch.apiary.io/#onproduction)

### Types of search

#### PlaceSearch

Search based on a `place_id`

Required parameters:
```
{
  place_id: 123,
  . . . (filter parameters)
}
```

#### PlaceStaySearch

Search based on a `place_id`, given dates `from` and `to`

Required parameters:
```
{
  place_id: 123,
  from: '2014-10-12',
  to: '2014-10-14',
  . . . (filter parameters)
}
```

#### PointSearch

Search based on `latitude`, `longitude` and a `radius`

Required parameters:
```
{
  latitude: 42.7000,
  longitude: 23.3333,
  radius: 100 #in Kilometers,
  . . . (filter parameters)
}
```

#### PointStaySearch

Search based on `latitude`, `longitude` and a `radius`, given dates `from` and `to`

Required parameters:
```
{
  latitude: 42.7000,
  longitude: 23.3333,
  radius: 100 #in Kilometers,
  from: '2014-10-12',
  to: '2014-10-14',
  . . . (filter parameters)
}
```

#### ViewportSearch

Search based on rectangle shape area, given two points

Required parameters:
```
{
  bottom_left_lat: 10.10,
  bottom_left_lon: 20.10,
  top_right_lat: 30.00,
  top_right_lon: 40.00,
  . . . (filter parameters)
}
```

#### ViewportStaySearch

Search based on rectangle shape area, given two points, given dates `from` and `to`

Required parameters:
```
{
  bottom_left_lat: 10.10,
  bottom_left_lon: 20.10,
  top_right_lat: 30.00,
  top_right_lon: 40.00,
  from: '2014-10-12',
  to: '2014-10-14',
  . . . (filter parameters)
}
```

### Filters

All filters are optional. The filters you can apply are based on:
- `types [array]` - types of properties
  - house
  - apartment
  - studio
  - boat
  - castle
- `features [array]`
  - swimming pool
  - internet
  - washing machine
- `bedrooms [integer]` - minimum number of bedrooms
- `guests [integer]` - minimum number of guests
- `price_min [integer]`
- `price_max [integer]`
- `currency [string] [default: 'EUR']`

### Aggregations

All aggregations are optional. The aggregations you can apply are based on:
- `aggregations` as a comma-separated string (e.g.: `type_of_property,garden`)
- `range_aggregations` as an array of comma-separated strings (e.g.: `price,-100,100-200,200-`)

Structure:

```ruby
{
  ... # other search params
  types: ['apartment', 'house'],
  features: ['internet', 'washing_machine'],
  bedrooms: 2,
  ...
}
```

##### Note about smoking and pets

If you are looking for properties where smoking or pets are allowed, you have to pass in **'smoking_allowed'** or **'pets_allowed'** respectively in the features array.

### Ordering
Available ordering:
- sqs_score
- price_desc
- price
- distance - only available with [PointSearch](#point-search)

```ruby
{
  ... # other search params
  order: 'sqs_score'
}
```

### Pagination

- `per_page [integer]` - number of results per page - defaults to 32
- `page [integer]` - page of the results set - defaults to 1

```ruby
{
  ... # other search params
  per_page: 30,
  page: 5
}
```

## Testing

In order to facilitate testing this gem can mimick the responses you receive from PSS. You should never ever stub responses coming from Property Search in your consumer apps. Instead you should use the test API provided by this gem. Example of usage in RSpec:

```ruby
describe MyController do

  using Ht::SearchClient::Test

  before do
    Ht::SearchClient::PlaceSearch
      .stub_request(place_id: 100)
      .with_results(properties: [
        { 'property_id' => 10 }
      ])
  end

  it 'is blue & rainbows' do
    Ht::SearchClient::PlaceSearch.new(place_id: 100).perform
    # returns a PSS-like response with property_id = 10
  end
end
```

`stub_request` arguments accept the same parameters as property search service (check apiary documentation), for the specific search class. i.e - `PlaceSearch` requires a `place_id`, `PointSearch` requires a `latitude`, `longitude` and `radius`, etc.. This also stubs behind the scenes with Webmock the HTTP request.

`with_results` allows you to mock the response returned. It accepts:
* an array of hashes representing the properties.
* the total number number or results available.

The total number of results is optional and defaults to the size of the properties array.
The resulting properties are set with default attributes, however depending on the type of the search, they can be overriden.

For normal searches (`PlaceSearch`, `PointSearch` & `ViewportSearch`):
  - `property_id` (required)
  - `average_price` (default: **100**)
  - `distance` (default: **nil**)

For stay searches (`PlaceStaySearch`, `PointStaySearch` & `ViewportStaySearch`):
  - `property_id` (required)
  - `stay_cost` (default: **1880.0**)
  - `total_commission` (default: **280.0**)
  - `commission_tax` (default: **0.0**)
  - `commission` (default: **280.0**)
  - `days_cost` (default: **1600.0**)
  - `extra_guest_price` (default: **0.0**)
  - `long_stay_discount` (default: **0.0**)
  - `distance` (default: **nil**)

A special note that this test API does not handle any kind of **ordering** or **results filtering**. The set of mocks given on `with_results` is exactly the one returned. Again, the goal of this API is only giving you specific property search service like responses.

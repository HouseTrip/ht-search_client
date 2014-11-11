require 'simplecov'
SimpleCov.minimum_coverage 100
SimpleCov.start

require 'ht/search_client'
require 'webmock/rspec'

Dir["./spec/support/**/*.rb"].sort.each { |f| require f}

Ht::SearchClient.configure do |config|
  config.url = 'http://test.com'
  config.username = 'username'
  config.password = 'password'
end

WebMock.disable_net_connect!(allow: /codeclimate/)

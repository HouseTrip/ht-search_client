require 'spec_helper'

module Ht::SearchClient
  describe Configuration do
    it_behaves_like 'a required configuration setting', 'url', 'example.com'
    it_behaves_like 'a required configuration setting', 'username', 'username'
    it_behaves_like 'a required configuration setting', 'password', 'password'
    it_behaves_like 'a configuration setting', 'monitor_class', Ht::SearchClient::StandardMonitor
    it_behaves_like 'a configuration setting', 'exception_handler_class', Ht::SearchClient::StandardExceptionHandler
    it_behaves_like 'a configuration setting', 'verbose', false
  end
end

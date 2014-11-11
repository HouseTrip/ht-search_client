module Ht::SearchClient
  class StandardMonitor
    def notify(event)
      puts "Notification for #{event}" if Ht::SearchClient.configuration.verbose
    end
  end
end

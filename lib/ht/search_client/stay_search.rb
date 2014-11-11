module Ht::SearchClient
  # Abstract class for every remote stay search using Search Service
  #
  # Define your own kind of search by inheriting from this class and defining
  # an #endpoint and #params methods
  #
  module StaySearch
    def search
      validate_date_params!

      super
    end

    def results
      search.fetch 'results'
    end

    private

    def allowed_params
      super + [:from, :to]
    end

    def validate_date_params!
      unless raw_params.has_key?(:from) && raw_params.has_key?(:to)
        raise KeyError, 'missing :from or :to parameter'
      end
    end
  end
end

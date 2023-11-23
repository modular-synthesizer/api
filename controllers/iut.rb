# frozen_string_literal: true

module Modusynth
  module Controllers
    class Iut < Controllers::Base
      post '/' do
        # We first select the collection to make queries on.
        collection = Mongoid.client(:iut)[:books]
        query = begin
          JSON.parse(symbolized_params[:query] || '{}')
        rescue StandardError
          {}
        end
        field = symbolized_params[:field] || '_id'
        page = symbolized_params[:page] || 0

        results = case symbolized_params[:action]
                  when 'distinct'
                    collection.find.distinct(field).to_a.slice(page * 50, (page + 1) * 50)
                  else
                    collection.find(query).limit(50).skip(50 * page)
                  end

        JSON.generate(results.to_a)
      end
    end
  end
end

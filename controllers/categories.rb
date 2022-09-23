module Modusynth
  module Controllers
    class Categories < Modusynth::Controllers::Base

      post '/' do
        halt 201, service.create(body_params).to_json
      end

      get '/' do
        results = Modusynth::Models::Category.all.map do |category|
          Modusynth::Decorators::Category.new(category).to_h
        end
        halt 200, results.to_json
      end

      def service
        Modusynth::Services::Categories.instance
      end
    end
  end
end
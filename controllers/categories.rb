module Modusynth
  module Controllers
    class Categories < Modusynth::Controllers::Base

      post '/' do
        halt 201, service.create(body_params).to_json
      end

      get '/' do
        halt 200, service.list.to_json
      end

      def service
        Modusynth::Services::Categories.instance
      end
    end
  end
end
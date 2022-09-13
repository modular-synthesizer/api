module Modusynth
  module Controllers
    class Parameters < Modusynth::Controllers::Base
      post '/' do
        halt 201, decorate(service.create(body_params)).to_json
      end

      def service
        Modusynth::Services::Parameters.instance
      end

      def decorate item
        Modunsynth::Decorators::Parameter.new(item).to_h
      end
    end
  end
end
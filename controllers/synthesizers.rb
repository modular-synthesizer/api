module Modusynth
  module Controllers
    class Synthesizers < Modusynth::Controllers::Base

      get '/' do

      end

      post '/' do
        halt 201, decorate(service.create(body_params)).to_json
      end

      def service
        Modusynth::Services::Synthesizers.instance
      end

      def decorate item
        Modusynth::Decorators::Synthesizer.new(item).to_h
      end
    end
  end
end
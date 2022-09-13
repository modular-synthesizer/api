module Modusynth
  module Controllers
    class Nodes < Modusynth::Controllers::Base
      post '/' do
        halt 200, decorate(service.create(body_params)).to_json
      end

      def decorate item
        Modusynth::Decorators::Module.new(item).to_h
      end

      def service
        Modusynth::Services::Modules.instance
      end
    end
  end
end
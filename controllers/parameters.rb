module Modusynth
  module Controllers
    class Parameters < Modusynth::Controllers::Base
      get '/' do
        results = service.list.map { |param| decorate(param).to_h }
        halt 200, {parameters: results}.to_json
      end

      post '/' do
        halt 201, decorate(service.create(body_params)).to_json
      end

      def service
        Modusynth::Services::Parameters.instance
      end

      def decorate item
        Modusynth::Decorators::Parameter.new(item).to_h
      end
    end
  end
end
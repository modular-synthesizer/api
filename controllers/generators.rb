# frozen_string_literal: true

module Modusynth
  module Controllers
    class Generators < Modusynth::Controllers::Base
      api_route 'post', '/', admin: true do
        generator = service.create(**symbolized_params)
        render_json 'generators/item', status: 201, generator:
      end

      api_route 'get', '/' do
        render_json 'generators/list', generators: service.list.to_a
      end

      api_route 'get', '/:name' do
        render_json 'generators/item', generator: service.get_by_name(params[:name])
      end

      def service
        Modusynth::Services::Generators.instance
      end
    end
  end
end

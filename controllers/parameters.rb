# frozen_string_literal: true

module Modusynth
  module Controllers
    class Parameters < Modusynth::Controllers::Base
      api_route 'get', '/' do
        descriptors = service.list
        render_json 'descriptors/list.json', descriptors:
      end

      api_route 'post', '/', admin: true do
        descriptor = service.create(**symbolized_params)
        render_json 'descriptors/_descriptor.json', status: 201, descriptor:
      end

      def service
        Modusynth::Services::Parameters.instance
      end
    end
  end
end

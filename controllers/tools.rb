# frozen_string_literal: true

module Modusynth
  module Controllers
    # Controller for the tools allowing the user to
    # create new modules in an existing synthesizer.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Tools < Base
      # The route to build the list of tools. It returns a subset
      # of fields from the tools to make it as light as possible.
      api_route 'get', '/' do
        halt 200, service.list.to_json
      end

      api_route 'get', '/:id' do
        halt 200, decorate(service.find_or_fail(params['id'])).to_json
      end

      api_route 'post', '/', admin: true do
        halt 201, decorate(service.create(body_params)).to_json
      end

      def service
        Modusynth::Services::Tools.instance
      end

      def decorate(item)
        Modusynth::Decorators::Tool.new(item).to_h
      end
    end
  end
end

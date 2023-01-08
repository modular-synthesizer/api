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
        items = Modusynth::Services::Tools::Find.instance.list
        halt 200, items.map { |i| decorate(i) }.to_json
      end

      api_route 'get', '/:id' do
        tool = Modusynth::Services::Tools::Find.instance.find_or_fail(id: payload[:id])
        halt 200, decorate(tool).to_json
      end

      api_route 'post', '/', admin: true do
        tool = Modusynth::Services::Tools::Create.instance.create(**symbolized_params)
        halt 201, decorate(tool).to_json
      end

      def decorate(item)
        Modusynth::Decorators::Tool.new(item).to_h
      end
    end
  end
end

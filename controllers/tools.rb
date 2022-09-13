module Modusynth
  module Controllers
    # Controller for the tools allowing the user to
    # create new modules in an existing synthesizer.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Tools < Base

      # The route to build the list of tools. It returns a subset
      # of fields from the tools to make it as light as possible.
      get '/' do
        results = service.list.map { |tool| decorate(tool) }
        halt 200, {tools: results}.to_json
      end

      get '/:name' do

      end

      post '/' do
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
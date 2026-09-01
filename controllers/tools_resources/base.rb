# frozen_string_literal: true

module Modusynth
  module Controllers
    module ToolsResources
      class Base < Modusynth::Controllers::Base
        def tools_service
          Modusynth::Services::Blueprints::Find.instance
        end

        api_route 'delete', '/:id', right: ::Rights::TOOLS_WRITE do
          service.remove(**symbolized_params, container:)
          halt 204
        end

        def blueprint
          tools_service.find_or_fail(id: symbolized_params[:blueprint_id], field: 'blueprint_id')
        end

        def container
          nil
        end
      end
    end
  end
end

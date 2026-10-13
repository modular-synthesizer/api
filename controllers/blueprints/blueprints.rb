# frozen_string_literal: true

module Modusynth
  module Controllers
    module Blueprints
      # Controller for the blueprints allowing the user to
      # create new modules in an existing synthesizer.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Blueprints < Base
        # The route to build the list of blueprints. It returns a subset
        # of fields from the blueprints to make it as light as possible.
        api_route 'get', '/', right: ::Rights::TOOLS_READ do
          render_json 'blueprints/list.json', blueprints: service.list(session:).to_a
        end

        api_route 'get', '/:id', right: ::Rights::TOOLS_READ do
          render_json 'blueprints/details.json', blueprint: service.find_or_fail(id: params[:id])
        end

        api_route 'post', '/', right: ::Rights::TOOLS_WRITE do
          blueprint = Modusynth::Services::Blueprints::Create.instance.create(**symbolized_params)
          render_json 'blueprints/details.json', status: 201, blueprint:
        end

        api_route 'put', '/:id', right: ::Rights::TOOLS_WRITE do
          blueprint = Modusynth::Services::Blueprints::Update.instance.find_and_update(**symbolized_params)
          render_json 'blueprints/details.json', blueprint:
        end

        api_route 'delete', '/:id', right: ::Rights::TOOLS_WRITE do
          Modusynth::Services::Blueprints::Delete.instance.remove(id: params[:id])
          halt 204
        end

        api_route 'post', '/:blueprint_id/parameters', right: ::Rights::TOOLS_WRITE do
          parameter = params_service.create_embedded(container: blueprint, collection: :parameters, **symbolized_params)
          render_json 'blueprints/_parameter.json', status: 201, parameter:
        end

        api_route 'put', '/:blueprint_id/parameters/:id', right: ::Rights::TOOLS_WRITE do
          parameter = params_service.find_in_blueprint(**symbolized_params, blueprint:)
          parameter = params_service.update(parameter, **symbolized_params)
          render_json 'blueprints/_parameter.json', parameter:
        end

        api_route 'delete', '/:blueprint_id/parameters/:id', right: ::Rights::TOOLS_WRITE do
          params_service.remove_in_blueprint(**symbolized_params, blueprint:)
          halt 204
        end

        api_route 'post', '/:blueprint_id/ports', right: ::Rights::TOOLS_WRITE do
          port = ports_service.create_embedded(container: blueprint, collection: :ports, **symbolized_params)
          render_json 'blueprints/_port.json', status: 201, port:
        end

        api_route 'put', '/:blueprint_id/ports/:id', right: ::Rights::TOOLS_WRITE do
          port = ports_service.find_in_blueprint(**symbolized_params, blueprint:)
          port = ports_service.update(port, **symbolized_params)
          render_json 'blueprints/_port.json', port:
        end

        api_route 'delete', '/:blueprint_id/ports/:id', right: ::Rights::TOOLS_WRITE do
          ports_service.remove_in_blueprint(**symbolized_params, blueprint:)
          halt 204
        end

        api_route 'post', '/:blueprint_id/controls', right: ::Rights::TOOLS_WRITE do
          control = controls_service.create_embedded(container: blueprint, collection: :controls, **symbolized_params)
          render_json 'blueprints/_control.json', status: 201, control:
        end

        api_route 'put', '/:blueprint_id/controls/:id', right: ::Rights::TOOLS_WRITE do
          control = controls_service.find_in_blueprint(**symbolized_params, blueprint:)
          control = controls_service.update(control, **symbolized_params)
          render_json 'blueprints/_control.json', control:
        end

        api_route 'delete', '/:blueprint_id/controls/:id', right: ::Rights::TOOLS_WRITE do
          controls_service.delete(**symbolized_params, collection: :controls)
          halt 204
        end

        def controls_service
          Modusynth::Services::Blueprints::Controls.instance
        end

        def ports_service
          Modusynth::Services::Blueprints::Ports.instance
        end

        def blueprint
          service.find_or_fail(id: symbolized_params[:blueprint_id], field: 'blueprint_id')
        end

        def params_service
          Modusynth::Services::Blueprints::Parameters.instance
        end

        def service
          Modusynth::Services::Blueprints::Find.instance
        end
      end
    end
  end
end

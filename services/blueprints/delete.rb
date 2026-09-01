module Modusynth
  module Services
    module Blueprints
      class Delete
        include Singleton
        include Modusynth::Services::Concerns::Deleter

        def delete blueprint
          blueprint.parameters.delete_all
          blueprint.ports.delete_all
          blueprint.controls.delete_all
          blueprint.modules.each do |mod|
            Modusynth::Services::Modules.instance.delete(mod)
          end
          blueprint.delete
        end

        def model
          Modusynth::Models::Blueprints::Blueprint
        end
      end
    end
  end
end
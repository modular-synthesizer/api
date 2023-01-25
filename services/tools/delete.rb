module Modusynth
  module Services
    module Tools
      class Delete
        include Singleton
        include Modusynth::Services::Concerns::Deleter

        def delete tool
          tool.parameters.delete_all
          tool.ports.delete_all
          tool.controls.delete_all
          Modusynth::Services::Modules.instance.remove_all(tool.modules)
          tool.delete
        end

        def model
          Modusynth::Models::Tool
        end
      end
    end
  end
end
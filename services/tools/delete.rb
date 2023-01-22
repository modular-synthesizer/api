module Modusynth
  module Services
    module Tools
      class Delete
        include Singleton
        include Modusynth::Services::Concerns::Deleter
        include Modusynth::Services::Concerns::Finder

        def process_delete tool
          tool.parameters.each do |parameter|
            parameter.delete
          end
          tool.ports.each do |port|
            port.delete
          end
          tool.controls.each do |control|
            control.delete
          end
          tool.modules.each do |mod|
            Modusynth::Services::Modules.instance.delete(mod.id.to_s)
          end
          tool.delete
        end

        def model
          Modusynth::Models::Tool
        end
      end
    end
  end
end
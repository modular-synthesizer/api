module Modusynth
  module Services
    module ToolsResources
      class Descriptors < Modusynth::Services::Base
        include Singleton
        
        def model
          Modusynth::Models::Tools::Descriptor
        end
      end
    end
  end
end

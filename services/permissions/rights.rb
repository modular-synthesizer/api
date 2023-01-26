module Modusynth
  module Services
    module Permissions
      class Rights < Modusynth::Services::Base
        include Singleton

        def build label: nil
          model.new(label:)
        end

        def list
          super.sort(label: 1).to_a
        end

        def model
          Modusynth::Models::Permissions::Right
        end
      end
    end
  end
end
# frozen_string_literal: true

module Modusynth
  module Services
    module Tools
      class Components < Modusynth::Services::Base
        def model
          ::Modusynth::Models::Tools::Component
        end
      end
    end
  end
end

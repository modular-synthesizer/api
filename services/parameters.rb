# frozen_string_literal: true

module Modusynth
  module Services
    class Parameters < Modusynth::Services::Base
      include Singleton

      def build(name: nil, default: nil, minimum: nil, maximum: nil, step: nil, precision: nil, **_)
        model.new(name:, default:, minimum:, maximum:, step:, precision:)
      end

      def model
        Modusynth::Models::Tools::Descriptor
      end
    end
  end
end

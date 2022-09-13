module Modusynth
  module Models
    module Tools
      class Parameter
        include Mongoid::Document

        field :targets, type: Array, default: []

        belongs_to :descriptor,
          class_name: '::Modusynth::Models::Tools::Descriptor',
          inverse_of: :parameters

        belongs_to :tool, class_name: '::Modusynth::Models::Tool', inverse_of: :parameters

        def targets_types
          return if targets.nil? || !targets.kind_of?(Array)
          targets.each.with_index do |target, index|
            return errors.add(:"targets[#{index}]", 'type') unless target.kind_of?(String)
          end
        end
      end
    end
  end
end
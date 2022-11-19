module Modusynth
  module Models
    module Tools
      class Parameter
        include Mongoid::Document

        store_in collection: 'tools_parameters'

        field :name, type: String

        field :targets, type: Array, default: []

        field :x, type: Integer, default: 0

        field :y, type: Integer, default: 0

        belongs_to :descriptor,
          class_name: '::Modusynth::Models::Tools::Descriptor',
          inverse_of: :parameters

        belongs_to :tool, class_name: '::Modusynth::Models::Tool', inverse_of: :parameters

        validates :name, presence: { message: 'required' }

        def targets_types
          return if targets.nil? || !targets.kind_of?(Array)
          targets.each.with_index do |target, index|
            return errors.add(:"targets[#{index}]", 'type') unless target.kind_of?(String)
          end
        end

        def name
          descriptor.name
        end

        scope :called, ->(name) {
          descriptors = Modusynth::Models::Tools::Descriptor.where(name: name)
          return where(:descriptor_id.in => descriptors.map(&:id))
        }
      end
    end
  end
end
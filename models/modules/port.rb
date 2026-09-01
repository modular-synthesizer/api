# frozen_string_literal: true

module Modusynth
  module Models
    module Modules
      # Instanciation of a port from its schema in the blueprint the module has been
      # created from. The instanciation will be used in the links.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Port
        include Mongoid::Document

        store_in collection: 'ports'

        belongs_to :module, class_name: '::Modusynth::Models::Module'

        belongs_to :descriptor, class_name: '::Modusynth::Models::Blueprints::Port', inverse_of: :ports

        def kind
          descriptor.kind
        end

        scope :inputs, -> { where(:descriptor.in => Modusynth::Models::Blueprints::Port.all.inputs.to_a) }
        scope :outputs, -> { where(:descriptor.in => Modusynth::Models::Blueprints::Port.all.outputs.to_a) }
      end
    end
  end
end

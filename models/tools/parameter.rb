module Modusynth
  module Models
    module Tools
      # A parameter represents a value of an AudioParam in the client-side application. It links a descriptor setting
      # constraints for the value of the parameter, and a set of targets being inner nodes of the tool the parameter is
      # declared into. After being instanciated, each tool parameter will generate a module parameter.
      #
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Parameter
        include Mongoid::Document

        store_in collection: 'tools_parameters'

        # @!attribute [rw] targets
        #   @return [Array<String>] The names of the inner nodes this parameter is applied onto.
        field :targets, type: Array, default: []

        # @!attribute [rw] descriptor
        #   @return [Modusynth::Models::Tools::Descriptor] the constraints applied to the current parameter
        belongs_to :descriptor, class_name: '::Modusynth::Models::Tools::Descriptor', inverse_of: :parameters

        scope :called, ->(name) {
          descriptors = Modusynth::Models::Tools::Descriptor.where(name: name)
          return where(:descriptor_id.in => descriptors.map(&:id))
        }
      end
    end
  end
end
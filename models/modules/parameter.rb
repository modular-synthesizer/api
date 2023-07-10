module Modusynth
  module Models
    module Modules
      # This represents the value a module has given to a parameter declared in its
      # tool descriptor. The value will be replacing the 
      class Parameter
        include Mongoid::Document

        store_in collection: 'parameters'

        field :value, type: Float

        belongs_to :template, class_name: '::Modusynth::Models::Tools::Parameter', inverse_of: :instances

        belongs_to :module, class_name: '::Modusynth::Models::Module', inverse_of: :value

        def name
          template.name
        end

        [:minimum, :maximum, :step, :precision].each do |field|
          define_method field do
            parameter.descriptor.send(field)
          end
        end

        scope :called, ->(name) {
          where(:parameter_id.in => Modusynth::Models::Tools::Parameter.called(name).map(&:id) )
        }
      end
    end
  end
end
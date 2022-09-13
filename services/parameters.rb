module Modusynth
  module Services
    class Parameters
      include Singleton

      def list
        Modusynth::Models::Tools::Descriptor.all.to_a
      end

      def create params
        object = Modusynth::Models::Tools::Descriptor.new(
          name: params['name'],
          default: params['default'],
          minimum: params['minimum'],
          maximum: params['maximum'],
          step: params['step'],
          precision: params['precision']
        )
        object.save!
        object
      end
    end
  end
end
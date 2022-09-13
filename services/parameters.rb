module Modusynth
  module Services
    class Parameters
      include Singleton

      def list
        Modusynth::Models::Tools::Parameter.all.to_a
      end

      def create params
        object = Modusynth::Models::Tools::Parameter.new(
          name: params['name'],
          targets: params['target'] || [],
          default: params['default'],
          minimum: params['minimum'],
          maximum: params['maximum'],
          step: params['step'],
          precision: params['precision'],
          targets: params['targets']
        )
        object.save!
        object
      end
    end
  end
end
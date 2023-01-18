module Modusynth
  module Services
    class Generators
      include Singleton
      include Modusynth::Services::Concerns::Creator
      include Modusynth::Services::Concerns::Finder

      def build name:, code:, **rest
        model.new(name:, code:)
      end

      def validate! name:, code:, **rest
        build(name:, code:).validate!
      end

      def get_by_name name
        model.find_by(name: name)
      end

      def model
        Modusynth::Models::Tools::Generator
      end
    end
  end
end
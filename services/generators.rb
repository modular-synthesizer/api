module Modusynth
  module Services
    class Generators < Modusynth::Services::Base
      include Singleton

      def build name: '', code: '', parameters: [], **_
        model.new(name:, code:, parameters: JSON.generate(parameters))
      end

      def validate! name:, code:, parameters: [], **_
        build(name:, code:, parameters:).validate!
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
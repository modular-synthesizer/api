module Modusynth
  module Services
    class Generators
      include Singleton

      def create payload
        generator = model.new(payload.slice('name', 'code'))
        generator.save!
        decorator.new(generator).to_h
      end

      def list
        model.all.map { |gen| decorator.new(gen).to_h }
      end

      def model
        Modusynth::Models::Tools::Generator
      end

      def decorator
        Modusynth::Decorators::Generator
      end
    end
  end
end
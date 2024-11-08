# frozen_string_literal: true

module Modusynth
  module Exceptions
    class BadRequest < StandardError
      attr_reader :key, :error

      def initialize(key, error)
        super "#{key}.#{error}"
        @key = key
        @error = error
      end

      def message
        { key:, error: }
      end
    end
  end
end

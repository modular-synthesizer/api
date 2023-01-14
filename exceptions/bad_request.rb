module Modusynth
  module Exceptions
    class BadRequest < StandardError
      attr_reader :key
      attr_reader :error

      def initialize key, error
        @key = key
        @error = error
      end

      def message
        {key:, error:}
      end
    end
  end
end
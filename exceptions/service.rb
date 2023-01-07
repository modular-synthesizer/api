module Modusynth
  module Exceptions
    class Service < StandardError
      # @!attribute [rw] key
      #   @return [String] the key of the payload on which the error occured.
      attr_reader :key
      # @!attribute [rw] error
      #   @return [String] the error type that has been triggered, eg. "required", "unknown", "minlength", etc.
      attr_reader :error
      # @!attribute [rw] status
      #   @return [Integer] the HTTP status to return when rendering this exception.
      attr_reader :status
      # @!attribute [rw] prefix
      #   @return [String] the path to the :key attribute in the payload if it is nested
      attr_reader :prefix

      def initialize key:, error:, prefix: nil, status: 400, **rest
        @key = key.to_s
        @error = error.to_s
        @status = status.to_i
        @prefix = prefix.nil? || prefix.empty? ? '' : "#{prefix}."
      end

      def self.from_unknown exception, prefix: nil
        raise Service.new key: exception.key, error: exception.error, status: 404, prefix:
      end

      def self.from_messages messages, prefix: nil
        key = messages.keys.first
        raise Service.new(key:, prefix:, error: messages[key].first)
      end

      def message
        {key: "#{prefix}#{key}", error:}.to_json
      end
    end
  end
end
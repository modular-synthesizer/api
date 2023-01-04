module Modusynth
  module Exceptions
    class Validation < StandardError

      attr_reader :prefix

      attr_reader :raw_messages

      def initialize(messages: {}, prefix: '')
        @raw_messages = messages
        @prefix = prefix
      end

      def messages
        Hash[raw_messages.map.each do |key, value|
          ["#{prefix}#{prefix != '' ? '.' : ''}#{key.to_s}".to_sym, value]
        end]
      end
    end
  end
end
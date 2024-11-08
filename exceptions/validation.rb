# frozen_string_literal: true

module Modusynth
  module Exceptions
    class Validation < StandardError
      attr_reader :prefix, :raw_messages

      def initialize(messages: {}, prefix: '')
        super "#{prefix}.errors"
        @raw_messages = messages
        @prefix = prefix
      end

      def messages
        raw_messages.transform_keys do |key|
          "#{prefix}#{prefix == '' ? '' : '.'}#{key}".to_sym
        end
      end
    end
  end
end

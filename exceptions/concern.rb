# frozen_string_literal: true

module Modusynth
  module Exceptions
    class Concern < StandardError
      attr_reader :caller, :called

      def initialize(caller:, called:)
        super("#{caller}.#{called}")
        @caller = caller
        @called = called
      end
    end
  end
end

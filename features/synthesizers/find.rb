# frozen_string_literal: true

module Modusynth
  module Features
    module Synthesizers
      class Find
        # @!attribute [r] id
        #   @return [String] the unique UUID of the synthesizers the user is looking for.
        # @!attribute [r] session
        #   @return [Models::Session] the current session authnticating the user.
        attr_reader :id, :session, :synthesizer

        def initialize id:, session:, **_
          @id = id
          @session = session
          @synthesizer = Modusynth::Models::Synthesizer.find_by(id:)
        end

        def run
          raise ::Modusynth::Exceptions.unknown if synthesizer.nil?

          synthesizer
        end
      end
    end
  end
end

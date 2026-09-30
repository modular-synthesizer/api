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

        def initialize(id:, session:, **_)
          @id = id
          @session = session
          @synthesizer = Modusynth::Models::Synthesizer.find_by(id:)
        end

        def run
          raise ::Modusynth::Exceptions.unknown unless exists(synthesizer:) && can_access(synthesizer:, session:)

          synthesizer
        end

        private

        def exists(synthesizer:)
          !synthesizer.nil?
        end

        def can_access(synthesizer:, session:, **_)
          synthesizer.memberships.map(&:account).find do |account|
            account.id == session.account.id
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module Modusynth
  module Features
    module Synthesizers
      class FindMembership
        # @!attribute [r] id
        #   @return [String] the unique UUID of the synthesizers the user is looking for.
        # @!attribute [r] session
        #   @return [Models::Session] the current session authnticating the user.
        attr_reader :session, :synthesizer, :membership

        def initialize(synthesizer:, session:, **_)
          @session = session
          @synthesizer = synthesizer
          @membership = synthesizer.memberships.find_by(account_id: session.account.id)
        end

        def run
          raise ::Modusynth::Exceptions.unknown unless exists(membership:)

          membership
        end

        private

        def exists(membership:)
          !membership.nil?
        end
      end
    end
  end
end

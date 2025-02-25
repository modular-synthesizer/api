# frozen_string_literal: true

module Modusynth
  module Models
    # A session represents the persisted connection of a user on the application. It is
    # valid for a whole week, then deemed invalid and discarded (but kept in the database).
    # Any request on a protected route made with an invalid session will be issued a
    # permission error and won't be successfully done.
    #
    # @author vincent Courtois <courtois.vincent@outlook.com>
    class Session
      include Mongoid::Document
      include Mongoid::Timestamps
      include Modusynth::Models::Concerns::Ownable

      store_in collection: 'sessions'

      # @!attributes [rw] duration
      #   @return [Integer] the duration of validity of the session in days.
      field :duration, type: Integer, default: 30

      field :token, type: String, default: -> { BSON::ObjectId.new.to_s }
      # @!attributes [rw] logged_out
      #   @return [Boolean] TRUE if the session has been closed, FALSE otherwise.
      field :logged_out, type: Boolean, default: false
      # @!attribute [rw] last_activity_date
      #   @return [DateTime] the date and time of the last logged request made with this session.
      field :last_activity_date, type: DateTime, default: DateTime.now

      belongs_to :account, class_name: '::Modusynth::Models::Account', inverse_of: :sessions

      # Checks if the session is expired or not. A session is considered expired if either :
      # * the user has logged out of it.
      # * the session has been created more than 30 days prior.
      # * the last activity of the session was more than 15 days ago.
      def expired?
        logged_out || expired_creation_date? || expired_last_activity_date?
      end

      def expired_creation_date?
        created_at < thirty_days_ago
      end

      def expired_last_activity_date?
        last_activity_date < fifteen_days_ago
      end

      def thirty_days_ago
        DateTime.now - 30
      end

      def fifteen_days_ago
        DateTime.now - 15
      end
    end
  end
end

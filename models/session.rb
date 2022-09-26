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

      field :duration, type: Integer, default: 604800

      field :token, type: String, default: ->{ BSON::ObjectId.new.to_s }

      field :logged_out, type: Boolean, default: false

      belongs_to :account, class_name: '::Modusynth::Models::Account', inverse_of: :sessions
      
      def expired?
        logged_out || created_at + 1000 * duration < DateTime.now
      end
    end
  end
end
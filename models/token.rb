# frozen_string_literal: true

module Modusynth
  module Models
    # A token represents a JWT token with a little bit more attributes. It can be refreshed to make the logged in
    # session longer and keep the user authenticated. It holds some date and times to be sure that we can track when and
    # how a token has been invalidated.
    #
    # @author vincent Courtois <courtois.vincent@outlook.com>
    class Token
      include Mongoid::Document
      include Mongoid::Timestamps

      store_in collection: 'tokens'

      # @!attributes [r] jwt_token
      #   @return [String] the encoded JWT token for this user session. It includes expiration, account_id, etc.
      field :jwt_token, type: String
      # @!attributes [r] refresh_token
      #   @return [String] the random string used to recreate a session more easily when this one has expired.
      field :refresh_token, type: String, default: -> { SecureRandom.hex(32) }
      # @!attributes [rw] refreshed_at
      #   @return [DateTime] the date and time when the token has been regenerated with the refresh token.
      field :refreshed_at, type: DateTime, default: nil
      # @!attributes [rw] invalidated_at
      #   @return [DateTime] the date and time when the token has been invalidated (the user manually logged out)
      field :invalidated_at, type: DateTime, default: nil

      scope :active, -> { where(refreshed_at: nil, invalidated_at: nil) }
    end
  end
end

module Modusynth
  module Models
    class Account
      include Mongoid::Document
      include Mongoid::Timestamps
    include ActiveModel::SecurePassword

      field :username, type: String
      # @!attribute [r] password_digest
      #   @return [String] the password of the user, encrypted with the Blowfish algorithm.
      field :password_digest, type: String

      field :email, type: String

      # @!attribute [w] password
      #   @return [String] password, in clear, of the user ; do not attempt to get the value, just set it when changing the password.
      # @!attribute [w] password_confirmation
      #   @return [String] the confirmation of the password, do not get, just set it ; it must be the same as the password.
      has_secure_password validations: false

      has_many :sessions, class_name: '::Modusynth::Models::Session', inverse_of: :account

      has_many :synthesizers, class_name: '::Modusynth::Models::Account', inverse_of: :account

      validates :username,
        presence: { message: 'required' },
        length: { minimum: 5, message: 'length', if: :username? },
        uniqueness: { message: 'uniq', if: :username? }

      validates :email,
        presence: { message: 'required' },
        uniqueness: { message: 'uniq', if: :email? },
        format: {
          with: /\A([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)\Z/,
          message: 'format',
          if: :email?
        }

      validates :password,
        presence: {message: 'required', if: ->{ !persisted? || password_digest_changed? }},
        confirmation: {message: 'confirmation', if: :password_digest_changed?}

      validates :password_confirmation,
        presence: {message: 'required', if: :password_digest_changed?}
    end
  end
end

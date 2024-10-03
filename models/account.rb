# frozen_string_literal: true

module Modusynth
  module Models
    class Account
      include Mongoid::Document
      include Mongoid::Timestamps
      include ActiveModel::SecurePassword

      store_in collection: 'accounts'

      field :username, type: String
      # @!attribute [r] password_digest
      #   @return [String] the password of the user, encrypted with the Blowfish algorithm.
      field :password_digest, type: String

      field :email, type: String

      field :admin, type: Boolean, default: false

      field :sample_rate, type: Integer, default: 44_100

      # @!attribute [w] password
      #   @return [String] password of the user; don't attempt to get the value, just set it when changing the password.
      # @!attribute [w] password_confirmation
      #   @return [String] the confirmation of the password, do not get, just set; it must be the same as the password.
      has_secure_password validations: false

      has_many :sessions, class_name: '::Modusynth::Models::Session', inverse_of: :account

      # has_many :synthesizers, class_name: '::Modusynth::Models::Account', inverse_of: :account
      has_many :memberships, class_name: '::Modusynth::Models::Social::Membership', inverse_of: :account

      has_many :applications, class_name: '::Modusynth::Models::OAuth::Application', inverse_of: :account

      has_and_belongs_to_many :groups,
                              class_name: '::Modusynth::Models::Permissions::Group',
                              inverse_of: :accounts

      validates :username,
                presence: { message: 'required' },
                length: { minimum: 5, message: 'length', if: :username? },
                uniqueness: { message: 'uniq', if: :username? }

      validates :email,
                presence: { message: 'required' },
                uniqueness: { message: 'uniq', if: :email? },
                format: {
                  with: /
                    \A([a-zA-Z0-9_\-.]+)
                    @
                    ((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)
                    |
                    (([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,6}|[0-9]{1,3})(\]?)\Z
                  /x,
                  message: 'format',
                  if: :email?
                }

      validates :sample_rate,
                numericality: { greater_than: 44_099, less_than: 192_001, message: 'value' }

      validates :password,
                presence: { message: 'required', if: -> { !persisted? || password_digest_changed? } },
                confirmation: { message: 'confirmation', if: :password_digest_changed? }

      validates :password_confirmation,
                presence: { message: 'required', if: :password_digest_changed? }

      def account=(account); end

      def account
        self
      end

      def all_groups
        default_groups = Modusynth::Models::Permissions::Group.where(is_default: true).to_a
        (default_groups + groups.to_a).uniq(&:id)
      end
    end
  end
end

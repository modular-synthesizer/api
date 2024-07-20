# frozen_string_literal: true

module Modusynth
  module Models
    module OAuth
      # An Oauth application provide another developing team credentials to access the API and ask for access to users
      # data (if the user has given them permissions to do so). A user SHOULD have a limited number of possible
      # applications linked to him. For now the application CANNOT be created on the API directly as this limitation
      # is not implemented.
      #
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Application
        include Mongoid::Document
        include Mongoid::Timestamps

        store_in collection: 'oauth_applications'

        field :name, type: String

        field :public_key, type: String

        field :private_key, type: String

        belongs_to :account, class_name: 'Modusynth::Models::Account', inverse_of: :application

        validates :name,
                  presence: { message: 'required' },
                  uniqueness: { message: 'uniq', if: :name? },
                  length: { minimum: 5, message: 'length', if: :name? }
      end
    end
  end
end

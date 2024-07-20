# frozen_string_literal: true

module Modusynth
  module Models
    module Concerns
      module Ownable
        extend ActiveSupport::Concern

        def belongs_to?(session)
          return unless respond_to? :account
          raise forbidden if session.expired?
          raise forbidden if account != session.account

          self
        end

        def forbidden
          Modusynth::Exceptions.forbidden 'auth_token'
        end
      end
    end
  end
end

# frozen_string_literal: true

module Modusynth
  module Decorators
    class Session < Draper::Decorator
      def to_h
        {
          token: object.token,
          created_at: object.created_at.iso8601(0),
          duration: object.duration,
          account_id: object.account.id.to_s,
          username: object.account.username,
          email: object.account.email,
          admin: object.account.admin
        }
      end
    end
  end
end

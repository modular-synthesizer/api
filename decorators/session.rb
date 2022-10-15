module Modusynth
  module Decorators
    class Session < Draper::Decorator
      def to_h
        {
          token: object.token,
          created_at: object.created_at.iso8601(0),
          duration: object.duration,
          account_id: object.account.id
        }
      end
    end
  end
end
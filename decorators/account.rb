module Modusynth
  module Decorators
    class Account < Draper::Decorator
      def to_h
        {
          id: object.id.to_s,
          email: object.email,
          username: object.username
        }
      end
    end
  end
end
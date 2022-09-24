module Modusynth
  module Services
    class Accounts
      include Singleton

      def create payload
        account = Modusynth::Models::Account.new(
          **payload.slice('username', 'email', 'password', 'password_confirmation')
        )
        account.save!
        decorator.new(account).to_h
      end

      def decorator
        Modusynth::Decorators::Account
      end
    end
  end
end
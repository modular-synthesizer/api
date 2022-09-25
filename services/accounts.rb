module Modusynth
  module Services
    class Accounts
      include Singleton

      def create payload
        account = model.new(
          **payload.slice('username', 'email', 'password', 'password_confirmation')
        )
        account.save!
        decorator.new(account).to_h
      end

      def find id
        return model.where(id: id).first
      end

      private

      def model
        Modusynth::Models::Account
      end

      def decorator
        Modusynth::Decorators::Account
      end
    end
  end
end
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

      def authenticate username, password
        account = find_or_fail_username username
        raise Modusynth::Exceptions.required 'password' if password.nil?
        raise Modusynth::Exceptions.forbidden 'username' unless account.authenticate(password)
        account
      end

      def find_or_fail_username username
        raise Modusynth::Exceptions.required 'username' if username.nil?
        account = model.where(username: username).first
        raise Modusynth::Exceptions.unknown 'username' if account.nil?
        account
      end

      def find_or_fail id
        account = model.where(id: id).first
        raise Modusynth::Exceptions.unknown 'id' if account.nil?
        account
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
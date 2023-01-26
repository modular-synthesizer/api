module Modusynth
  module Services
    class Accounts < Modusynth::Services::Base
      include Singleton

      def build username: nil, email: nil, password: nil, password_confirmation: nil, **rest
        model.new(username:, email:, password:, password_confirmation:)
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

      def model
        Modusynth::Models::Account
      end
    end
  end
end
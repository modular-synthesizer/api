module Modusynth
  module Services
    class Sessions
      include Singleton

      def create payload
        account = account payload
        session = model.create(**payload.slice('account_id', 'duration'))
        session.save!
        decorator.new(session).to_h
      end

      def delete token, auth_session
        session = Modusynth::Models::Session.where(token: token).first
        raise Modusynth::Exceptions.unknown 'token' if session.nil?
        if session.account.id.to_s != auth_session.account.id.to_s || auth_session.expired?
          raise Modusynth::Exceptions.forbidden 'auth_token'
        end
        session.logged_out = true
        session.save!
        session
      end

      private

      def account payload
        raise Modusynth::Exceptions.required 'account_id' unless payload.key? 'account_id'
        account = Modusynth::Services::Accounts.instance.find payload['account_id']
        raise Modusynth::Exceptions.unknown 'account_id' if account.nil?
        account
      end

      def decorator
        Modusynth::Decorators::Session
      end

      def model
        Modusynth::Models::Session
      end
    end
  end
end
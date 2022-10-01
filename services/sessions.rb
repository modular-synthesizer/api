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

      def delete session
        session.logged_out = true
        session.save!
        session
      end

      def find_or_fail token, field = 'id'
        session = Modusynth::Models::Session.where(token: token).first
        raise Modusynth::Exceptions.unknown field if session.nil?
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

      def ownership
        Modusynth::Services::Ownership.instance
      end
    end
  end
end
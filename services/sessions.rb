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
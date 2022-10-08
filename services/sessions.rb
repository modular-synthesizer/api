module Modusynth
  module Services
    class Sessions
      include Singleton

      def create payload
        account = accounts_service.authenticate payload['username'], payload['password']
        session = model.create(account: account, **payload.slice('duration'))
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

      def accounts_service
        Modusynth::Services::Accounts.instance
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
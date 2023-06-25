module Modusynth
  module Services
    class Sessions < Modusynth::Services::Base
      include Singleton

      def build(username: nil, password: nil, duration: 604800, **_)
        account = Modusynth::Services::Accounts.instance.authenticate(username, password)
        model.create(account:, duration:)
      end

      def delete session
        session.logged_out = true
        session.save
      end

      def find(id:, **_)
        model.find_by(token: id)
      end

      def model
        Modusynth::Models::Session
      end
    end
  end
end
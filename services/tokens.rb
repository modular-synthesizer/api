module Modusynth
  module Services
    class Tokens < Modusynth::Services::Base
      include Singleton

      # Creates a token after authenticating the user. If anything goes wrong, we raise the exact
      # same error while logging problems underneath. This way an eventual attacker may not know
      # what the problem is and adapt to it.
      #
      # @param username [String] the nickname of the user trying to log in.
      # @param password [String] the password of the user trying to log in.
      def build(username:, password:, **_)
        account = accounts_service.authenticate(username, password)
        model.new(jwt_token: create_jwt_token(account:))
      end

      private

      def create_jwt_token(account:, **_)
        payload = {
          sub: account.username,
          jti: SecureRandom.hex(32),
          exp: Time.now.to_i + 600,
          iss: 'Synple'
        }
        JWT.encode(payload, account.jwt_secret, 'HS256')
      end

      def accounts_service
        Modusynth::Services::Accounts.instance
      end

      def model
        Modusynth::Models::Token
      end
    end
  end
end

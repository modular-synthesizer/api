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
      def create(username:, password:, **_)
        account = Modusynth::Services::Accounts.instance.authenticate(username, password)
        jti = SecureRandom.hex(32)
        instance = model.new(jwt_token_id: jti)
        instance.save!
        {
          jwt_token: create_jwt_token(account:, jti:),
          refresh_token: instance.refresh_token
        }
      end

      def parse(auth_token:, account:, **_)
        token = JWT.decode(auth_token, account.jwt_secret, 'HS256')
        raise Modusynth::Exceptions.forbidden 'username' if token[0]['sub'] != account.username
        raise Modusynth::Exceptions.forbidden 'username' if token[0]['iss'] != 'Synple'

        token
      end

      private

      def create_jwt_token(account:, jti:, **_)
        payload = {
          sub: account.username,
          jti:,
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

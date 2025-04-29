module Modusynth
  module Services
    module OAuth
      class Applications < Modusynth::Services::Base
        include Singleton

        def build(name: nil, session:, **_)
          build_with_account(name:, account: session.account)
        end

        def build_with_account(name: nil, account: nil, **_)
          model.new(name:, account:, api_key: SecureRandom.hex(64))
        end

        def authenticate(api_key: nil, **_)
          application = model.find_by(api_key:)
          raise Modusynth::Exceptions.forbidden 'application' if application.nil?
        end

        def model
          Modusynth::Models::OAuth::Application
        end
      end
    end
  end
end
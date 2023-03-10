module Modusynth
  module Services
    module OAuth
      class Applications < Modusynth::Services::Base
        include Singleton

        def build(name: nil, session:, **_)
          model.new(
            name:,
            account: session.account,
            public_key: SecureRandom.hex(16),
            private_key: SecureRandom.hex(64)
          )
        end

        def authenticate public_key, private_key
          application = model.find_by(public_key:, private_key:)
          raise Modusynth::Exceptions.forbidden 'application' if application.nil?
        end

        def model
          Modusynth::Models::OAuth::Application
        end
      end
    end
  end
end
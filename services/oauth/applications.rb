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

        def model
          Modusynth::Models::OAuth::Application
        end
      end
    end
  end
end
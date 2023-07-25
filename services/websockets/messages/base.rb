module Modusynth
  module Services
    module Websockets
      module Messages
        class Base
          attr_reader :payload

          attr_reader :sender

          def initialize payload: {}, sender: nil
            @payload = payload
            @sender = sender
          end

          def recipients
            raise NotImplementError.new
          end
        end
      end
    end
  end
end
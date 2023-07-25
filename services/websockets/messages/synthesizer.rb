module Modusynth
  module Websockets
    module Messages
      class Synthesizer < Modusynth::Websockets::Messages::Base

        def recipients
          synthesizer = Modusynth::Services::Synthesizers.instance.find_or_fail **payload
          # Return all the active sessions of all the users linked to the synthesizer
        end
      end
    end
  end
end
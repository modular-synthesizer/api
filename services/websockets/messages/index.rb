module Modusynth
  module Services
    module Websockets
      module Messages
        autoload :Base, './services/websockets/messages/base'
        autoload :Create, './services/websockets/messages/create'
        autoload :Empty, './services/websockets/messages/empty'
        autoload :Synthesizer, './services/websockets/messages/synthesizer'
      end
    end
  end
end
module Modusynth
  module Services
    module Websockets
      module Messages
        class Empty < Base
          def recipients
            []
          end
        end
      end
    end
  end
end
module Modusynth
  module Websockets
    module Messages
      class Create
        include Singleton

        def create message: nil
          payload = message[:payload] || {}
          return Empty.new(payload) unless message.key? :type

          case message[:type]
          when 'synthesizer'
            return Synthesizer.new payload
          else
            return Empty.new payload
          end
        end
      end
    end
  end
end
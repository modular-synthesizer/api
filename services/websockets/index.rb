# frozen_string_literal: true

module Modusynth
  module Services
    module Websockets
      autoload :Channel, './services/websockets/channel'
      autoload :Create, './services/websockets/create'
      autoload :Messages, './services/websockets/messages/index'
    end
  end
end

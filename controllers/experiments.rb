# frozen_string_literal: true

module Modusynth
  module Controllers
    class Experiments < Modusynth::Controllers::Base
      api_route 'get', '/' do
        halt 200, 'ok'
      end
    end
  end
end

module Modusynth
  module Controllers
    class Bare < Sinatra::Base
      get '/' do
        halt 200, 'ok'
      end
    end
  end
end

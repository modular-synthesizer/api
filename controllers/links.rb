module Modusynth
  module Controllers
    class Links < Modusynth::Controllers::Base
      get '/' do
        halt 200, [].to_json
      end
    end
  end
end
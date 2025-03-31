# frozen_string_literal: true

module Modusynth
  module Controllers
    class Experiments < Sinatra::Base
      get '/' do
        halt 200, { message: 'ok' }.to_json
      end
    end
  end
end

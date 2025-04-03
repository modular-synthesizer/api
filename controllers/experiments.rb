# frozen_string_literal: true

module Modusynth
  module Controllers
    class Experiments < Modusynth::Controllers::Base
      api_route 'get', '/', right: ::Rights::SYNTHESIZERS_READ do
        Mongo::Logger.level = 0
        mods = Modusynth::Services::Modules.instance.eager_load(**symbolized_params)
        render_json 'modules/list.json', mods:
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

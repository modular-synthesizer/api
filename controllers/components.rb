# frozen_string_literal: true

module Modusynth
  module Controllers
    class Components < Modusynth::Controllers::Base
      api_route 'get', '/', right: ::Rights::SYNTHESIZERS_READ do
        component = service.create(**symbolized_params)
        render_json 'components/_component', component:
      end
      api_route 'post', '/', right: ::Rights::ACCOUNTS_ADMIN do
      end
      api_route 'put', '/:id', right: ::Rights::ACCOUNTS_ADMIN do
      end
      api_route 'delete', '/:id', right: ::Rights::ACCOUNTS_ADMIN do
      end
    end

    def service
      ::Modusynth::Services::Tools::Components.instance
    end
  end
end

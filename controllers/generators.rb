# frozen_string_literal: true

module Modusynth
  module Controllers
    class Generators < Modusynth::Controllers::Base
      api_route 'post', '/', admin: true do
        halt 201, service.create(body_params).to_json
      end

      api_route 'get', '/' do
        generators = service.list
        jbuilder :'generators/list', {locals: {generators:}}
      end

      api_route 'get', '/:name' do
        generator = service.get_by_name(params[:name])
        jbuilder :'generators/item', locals: {generator:}
      end

      def service
        Modusynth::Services::Generators.instance
      end
    end
  end
end

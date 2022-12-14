# frozen_string_literal: true

module Modusynth
  module Controllers
    class Groups < Modusynth::Controllers::Base
      api_route 'get', '/' do
        results = service.list.map do |group|
          decorate(group)
        end
        halt 200, results.to_json
      end

      get '/:id' do
        halt 200, find_or_fail(id: payload[:id]).to_h.to_json
      end

      api_route 'post', '/', admin: true do
        group = service.create(slug: payload[:slug])
        halt 201, decorate(group).to_json
      end

      api_route 'put', '/:id', admin: true do
        group = service.update(payload)
        halt 200, decorate(group).to_json
      end

      delete '/:id' do
        service.delete(id: payload[:id])
        halt 204
      end

      private

      def service
        Modusynth::Services::Permissions::Groups.instance
      end

      def decorate(group)
        Modusynth::Decorators::Group.new(group).to_h
      end
    end
  end
end

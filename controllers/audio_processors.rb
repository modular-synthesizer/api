module Modusynth
  module Controllers
    class AudioProcessors < ::Modusynth::Controllers::Base
      api_route 'get', '/' do
        public_procs = service.list(public: true).to_a
        owned = service.list(public: false, account: @session.account).to_a
        render_json 'audio_processors/list.json', processors: public_procs + owned
      end

      api_route 'get', '/:id' do
        content_type 'text/javascript'
        halt 200, service.get_and_format(**symbolized_params)
      end

      api_route 'post', '/', admin: true do
        processor = service.create(account: @session.account, **symbolized_params)
        render_json 'audio_processors/_processor.json', status: 201, processor:
      end

      api_route 'delete', '/:id', admin: true do
        service.remove(id: params[:id])
        halt 204
      end

      def service
        ::Modusynth::Services::AudioProcessors.new
      end
    end
  end
end
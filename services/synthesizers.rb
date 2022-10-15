module Modusynth
  module Services
    class Synthesizers
      include Singleton

      def list account
        return model.all.to_a if account.admin
        model.where(account: account).to_a
      end

      def find_or_fail id, field = 'id'
        synthesizer = Modusynth::Models::Synthesizer.find(id)
        raise Modusynth::Exceptions.unknown(field) if synthesizer.nil?
        synthesizer
      end

      def create payload, account
        payload = payload.slice('name', 'slots', 'racks')
        synthesizer = Modusynth::Models::Synthesizer.new(
          account: account, **payload
        )
        synthesizer.save!
        synthesizer
      end

      def update synthesizer, payload
        synthesizer.update(**payload.slice('x', 'y', 'scale'))
        synthesizer
      end

      def delete synthesizer
        synthesizer.modules.delete_all
        synthesizer.delete
      end

      private

      def model
        Modusynth::Models::Synthesizer
      end
    end
  end
end
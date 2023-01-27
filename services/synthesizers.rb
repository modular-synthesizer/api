module Modusynth
  module Services
    class Synthesizers < Modusynth::Services::Base
      include Singleton

      def list account
        return model.all.to_a if account.admin
        model.where(account: account).to_a
      end

      def build account:, name: nil, slots: 50, racks: 1, **_
        model.new(account:, name:, slots:, racks:)
      end

      def update synthesizer, payload
        synthesizer.update(**payload.slice('x', 'y', 'scale'))
        synthesizer
      end

      def delete synthesizer
        Modusynth::Services::Modules.instance.remove_all(synthesizer.modules)
        synthesizer.delete
      end

      def model
        Modusynth::Models::Synthesizer
      end
    end
  end
end
module Modusynth
  module Services
    class Ports < Modusynth::Services::Base
      include Singleton

      def find_or_fail(id: nil, synthesizer: nil, field: 'from', **_)
        raise Modusynth::Exceptions.required(field) if id.nil?
        synthesizer.modules.each do |mod|
          found = mod.ports.where(id:).first
          return found unless found.nil?
        end
        raise Modusynth::Exceptions.unknown(field)
      end

      def delete port
        Modusynth::Models::Link.where(from: port).delete_all
        Modusynth::Models::Link.where(to: port).delete_all
        port.delete
      end

      def model
        Modusynth::Models::Modules::Port
      end
    end
  end
end
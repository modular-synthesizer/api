module Modusynth
  module Services
    class Ports
      include Singleton

      def find_or_fail(id: nil, synthesizer: nil, field: 'from', **_)
        raise Modusynth::Exceptions.required(field) if id.nil?
        synthesizer.modules.each do |mod|
          found = mod.ports.where(id:).first
          return found unless found.nil?
        end
        raise Modusynth::Exceptions.unknown(field)
      end
    end
  end
end
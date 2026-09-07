module Modusynth
  module Services
    class Ports < Modusynth::Services::Base
      include Singleton

      def find_or_fail(id: nil, field: 'from', **_)
        raise Modusynth::Exceptions.required(field) if id.nil?

        instance = ::Modusynth::Models::Modules::Port.find_by(id:)
        raise Modusynth::Exceptions::Unknown.new(field, 'unknown') if instance.nil?

        instance
      end

      def delete(port)
        delete_links port
        port.delete
      end

      def delete_links(port)
        Modusynth::Models::Link.where(from: port).delete_all
        Modusynth::Models::Link.where(to: port).delete_all
      end

      def model
        Modusynth::Models::Modules::Port
      end
    end
  end
end

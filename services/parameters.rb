module Modusynth
  module Services
    class Parameters
      include Modusynth::Services::Concerns::Finder
      include Singleton

      def find_or_fail module_id: nil, id: nil, **_
        mod = ::Modusynth::Services::Modules.instance.find_or_fail(id: module_id)
        param = mod.parameters.find_by(id:)
        raise ::Modusynth::Exceptions::Unknown.new('id') if param.nil?

        param
      end

      def update(session: nil, module_id: nil, id: nil, value: nil, **_)
        parameter = find_or_fail(module_id:, id:)
        synthesizer = parameter.module.synthesizer
        membership = Memberships.instance.find_or_fail_by(session:, synthesizer:)
        raise Modusynth::Exceptions.forbidden('auth_token') if membership.nil? || membership.type_read?

        if value.nil? || value < parameter.minimum || value > parameter.maximum
          raise Modusynth::Exceptions::BadRequest.new('value', 'boundaries')
        end

        parameter.value = value
        parameter.save!
        parameter
      end

      def model
        Modusynth::Models::Modules::Parameter
      end
    end
  end
end

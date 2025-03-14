module Modusynth
  module Services
    class Parameters
      include Modusynth::Services::Concerns::Finder
      include Singleton

      def update(session: nil, id: nil, value: nil, **_)
        parameter = find_or_fail(id:)
        synthesizer = parameter.module.synthesizer
        membership = Memberships.instance.find_or_fail_by(session:, synthesizer:)
        raise Modusynth::Exceptions.forbidden('auth_token') if membership.nil? || membership.type_read?

        template = parameter.template
        if value.nil? || value < template.minimum || value > template.maximum
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
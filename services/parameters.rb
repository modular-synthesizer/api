module Modusynth
  module Services
    # Dedicated service to handle parameters edition. Now that we're trying to achieve collaborative capabilities,
    # parameters are a bit trickier to edit than previously thought as they can be monopolized and blocked.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Parameters
      include Singleton
      include Modusynth::Services::Concerns::Finder
      include Modusynth::Services::Concerns::Updater

      def update(session: nil, id: nil, module_id: nil, blocked: false, value: nil, **_)
        parameter = find_in_module(id:, module_id:)
        update_value(session:, parameter:, value:) unless blocked || value.nil?
        update_blocked_state(session:, parameter:, value: blocked) unless blocked.nil?
        parameter
      end

      def find_in_module(id: nil, module_id: nil)
        mod = modules.find_or_fail(id: module_id, field: 'module_id')
        parameter = mod.parameters.find(id)
        raise Modusynth::Exceptions::Unknown.new('id', 'unknown') if parameter.nil?

        parameter
      end

      def update_blocked_state(session: nil, parameter: nil, value: false)
        parameter.update_attributes(
          last_blocked_date: value ? DateTime.now : nil,
          blocker: value ? session.account : nil
        )
        parameter.save!
        parameter
      end

      # Updates the value of a parameter with a new, non-clamped value.
      # The edition WILL NOT validate if the value is not in the boundaries of the parameter.
      # @param parameter [Modusynth::Models::Modules::Parameter] the parameter to edit
      # @param value [Float] the value to set the parameter with, as a floating point decimal.
      # @return [Modusynth::Models::Modules::Parameter] the parameter after edition.
      def update_value(session: nil, parameter: nil, value: nil)
        unless parameter.editable_by?(account: session.account)
          raise Modusynth::Exceptions::BadRequest.new('value', 'blocked')
        end

        template = parameter.template
        if value < template.minimum || value > template.maximum
          raise Modusynth::Exceptions::BadRequest.new('value', 'boundaries')
        end

        parameter.update_attributes(value:)
        parameter.save!
        parameter
      end

      def modules
        Modusynth::Services::Modules.instance
      end
    end
  end
end

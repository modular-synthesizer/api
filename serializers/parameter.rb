# frozen_string_literal: true

module Modusynth
  module Serializers
    class Parameter < ::Modusynth::Serializers::Base
      def to_h(tab_id = nil)
        data = {
          id: model.id,
          name: model.name,
          minimum: model.template.minimum,
          maximum: model.template.maximum,
          precision: model.template.precision,
          field: model.template.field,
          value: model.value,
          targets: model.template.targets,
          blocked: model.editable?
        }
        data[:tab_id] = tab_id unless tab_id.nil?
        data
      end
    end
  end
end

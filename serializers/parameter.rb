# frozen_string_literal: true

module Modusynth
  module Serializers
    class Parameter
      def to_h
        fields(:id, :step, :minimum, :maximum, :precision, :name, :value, :field, :targets)
          .merge({ blocked: model.blocked? })
      end
    end
  end
end

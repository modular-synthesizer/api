module Modusynth
  module Serializers
    class Base
      attr_reader :model

      def initialize(wrapped_model)
        @model = wrapped_model
      end

      def fields *fields
        fields.inject({}) { |result, field| result.merge({ "#{field}": model.send(field) }) }
      end

      def to_json(*)
        to_h.to_json(*)
      end
    end
  end
end

module Modusynth
  module Helpers
    module Payloads
      def body_params
        request.body.rewind
        JSON.parse(request.body.read.to_s).merge(params)
      rescue JSON::ParserError
        params
      end

      # This method is destined to replace the body_params method as it
      # is easier to read, and correctly transforms all keys in symbols.
      def payload
        body_params.transform_keys(&:to_sym)
      end

      def symbolized_params
        symbolize!(body_params)
      end

      def symbolize! parameters
        return parameters.map { |p| symbolize! p } if parameters.is_a? Array
        return parameters unless parameters.is_a?(Hash)
        Hash[parameters.map {|k, v| [k.to_sym, symbolize!(v)]}]
      end
    end
  end
end
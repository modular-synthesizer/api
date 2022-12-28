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
    end
  end
end
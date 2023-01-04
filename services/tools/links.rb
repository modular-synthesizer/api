module Modusynth
  module Services
    module Tools
      # This service holds all the logic to validate and create new inner links between inner nodes.
      class Links
        include Modusynth::Services::Concerns::Creator
        include Singleton

        def build from: nil, to: nil
          Modusynth::Models::Tools::InnerLink.new(**validate!(from:, to:))
        end

        def validate! prefix:, **payload
          [:from, :to].each do |link_end|
            unless payload.key?(link_end) && !payload[link_end].nil?
              raise Modusynth::Exceptions.required("#{prefix}#{prefix == '' ? '' : '.'}#{link_end}")
            end
          end
          Modusynth::Models::Tools::InnerLink.new(**payload).validate!
          payload
        end
      end
    end
  end
end
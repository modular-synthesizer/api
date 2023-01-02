module Modusynth
  module Services
    module Tools
      # This service holds all the logic to validate and create new inner links between inner nodes.
      class Links
        include Modusynth::Services::Concerns::Creator
        include Singleton

        def build index:, from: nil, to: nil
          Modusynth::Models::Tools::InnerLink.new(**validate!(index:, from:, to:))
        end

        def validate! index:, **payload
          [:from, :to].each do |link_end|
            unless payload.key?(link_end) && !payload[link_end].nil?
              raise Modusynth::Exceptions.required("innerLinks[#{index}].#{link_end}")
            end
            [:node, :index].each do |field|
              unless payload[link_end].key?(field) && !payload[link_end][field].nil?
                raise Modusynth::Exceptions.required("innerLinks[#{index}].#{link_end}.#{field}")
              end
            end
            if payload[link_end][:index] < 0
              raise Modusynth::Exceptions::BadRequest.new("innerLinks[#{index}].#{link_end}.index", 'value')
            end
          end
          payload
        end
      end
    end
  end
end
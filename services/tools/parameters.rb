module Modusynth
  module Services
    module Tools
      # This service allow for the creation of inner nodes in tools.
      class Parameters
        include Modusynth::Services::Concerns::Creator
        include Singleton

        def build descriptor: nil, targets: [], tool: nil, x: 0, y: 0, component: nil

        end

        
        results = payload['parameters'].map.with_index do |param, idx|
          if param['descriptor'].nil?
            raise Modusynth::Exceptions.required("parameters[#{idx}].descriptor")
          end
          descriptor = Modusynth::Models::Tools::Descriptor.find_by(id: param['descriptor'])
          raise Modusynth::Exceptions.unknown("parameters[#{idx}]") if descriptor.nil?
          parameter = Modusynth::Models::Tools::Parameter.new(
            descriptor: descriptor,
            targets: param['targets'] || [],
            tool: tool,
            x: param['x'],
            y: param['y'],
            component: param['component']
          )
          parameter.save!
          parameter
      end
    end
  end
end
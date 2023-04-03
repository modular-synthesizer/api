module Modusynth
  module Services
    module Tools
      class Update < Modusynth::Services::Base
        include Singleton

        def update instance, **payload
          instance.update(payload.slice(:name, :slots))
          if payload.key?(:categoryId)
            category =  Modusynth::Services::Categories.instance.find_or_fail(id: payload[:categoryId])
            instance.update(category:)
          end
          if payload[:nodes].instance_of?(Array)
            instance.inner_nodes = InnerNodes.instance.build_all(payload[:nodes], prefix: 'nodes')
          end
          if payload[:links].instance_of?(Array)
            instance.inner_links = Links.instance.build_all(payload[:links], prefix: 'links')
          end
          if payload[:ports].instance_of?(Array)
            instance.ports = update_association(
              previous: instance.ports,
              next_list: payload[:ports],
              service: Ports.instance,
              prefix: 'ports'
            )
          end
          if payload[:parameters].instance_of?(Array)
            instance.parameters = update_association(
              previous: instance.parameters,
              next_list: payload[:parameters],
              service: Parameters.instance,
              prefix: 'parameters'
            )
            instance.parameters.each do |parameter|
              instance.modules.each do |mod|
                if mod.parameters.where(parameter:).first.nil?
                  Modusynth::Models::Modules::Parameter.create(
                    module: mod, parameter:, value: parameter.descriptor.default
                  )
                end
              end
            end
          end
          if payload[:controls].instance_of?(Array)
            instance.controls.delete_all
            instance.controls = Modusynth::Services::Tools::Controls.instance.build_all(
              payload[:controls],
              prefix: 'controls'
            )
          end
          instance
        end

        def update_association previous:, next_list:, service:, prefix:
          # Step 1 : delete items from previous not in next (+ mod ports and links)
          previous.each do |item|
            if next_list.select { |i| i[:id] == item.id.to_s }.count == 0
              service.remove(id: item.id)
            end
          end
          # Step 2 : insert the items in next that have no UUIDs and return the list
          next_list.map.with_index do |item, idx|
            if item.key?(:id) && (item[:id] != '')
              service.find_or_fail(id: item[:id], field: "#{prefix}[#{idx}].id")
            else
              item.delete(:id)
              service.create(**item, prefix: "#{prefix}[#{idx}]")
            end
          end
        end

        def model
          Modusynth::Models::Tool
        end
      end
    end
  end
end

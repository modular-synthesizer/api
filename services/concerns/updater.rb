module Modusynth
  module Services
    module Concerns
      module Updater
        extend ActiveSupport::Concern

        def find_and_update(id:, container: nil, **payload)
          unless respond_to? :model, true
            raise Modusynth::Exceptions::Concern.new(
              caller: 'find_and_update',
              called: 'model'
            )
          end
          container = model if container.nil?
          instance = find_or_fail(id:, container:)
          if respond_to? :update, true
            instance = update(instance, **payload)
          else
            payload.each do |field, value|
              instance.send("#{field}=", value) if instance.respond_to?(:"#{field}=")
            end
          end
          instance.save!
          instance
        end
      end
    end
  end
end
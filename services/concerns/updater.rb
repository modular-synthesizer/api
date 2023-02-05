module Modusynth
  module Services
    module Concerns
      module Updater
        extend ActiveSupport::Concern

        def find_and_update(id:, **payload)
          unless respond_to? :model, true
            raise Modusynth::Exceptions::Concern.new(
              caller: 'find_and_update',
              called: 'model'
            )
          end
          instance = find_or_fail(id:)
          if respond_to? :update, true
            instance = update(instance, **payload)
          else
            payload.each do |value, field|
              instance.send("#{field}=", value) if field.respond_to?(:"#{field}=")
            end
          end
          instance.save!
          instance
        end
      end
    end
  end
end
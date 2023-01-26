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
          instance = model.find(id)
          raise Modusynth::Exceptions.unknown('id') if instance.nil?
          if respond_to? :update, true
            update(instance, **payload)
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
module Modusynth
  module Services
    module Concerns
      module Deleter
        extend ActiveSupport::Concern

        def delete(id:)
          unless respond_to? :find, true
            raise Modusynth::Exceptions::Concern.new(
              caller: 'delete',
              called: 'find'
            )
          end
          instance = find(id: id)
          if respond_to? :process_delete
            process_delete(instance)
          elsif instance.nil?
            return false
          else
            return instance.delete
          end
        end
      end
    end
  end
end
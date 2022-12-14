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
          return instance.nil? ? false : instance.delete
        end
      end
    end
  end
end
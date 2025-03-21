module Modusynth
  module Services
    module Concerns
      module Deleter
        extend ActiveSupport::Concern

        # Tries to find a record, and if found, removes it from the database. This depends
        # On the service implementing the Concerns::Finder class o be able to find the
        # record before deleting it. If the record is not found, it will NOT raise an error
        # as the controllers are NOT supposed to return 404 when a record is not found.
        def remove(id:, container: nil, **_)
          unless respond_to? :model, true
            raise Modusynth::Exceptions::Concern.new(
              caller: 'delete',
              called: 'model'
            )
          end
          container = model if container.nil?
          instance = container.where(id: id).first
          if instance.nil?
            false
          else
            respond_to?(:delete) ? delete(instance) : instance.delete
          end
        end

        def remove_if_owner(id:, account:)
          instance = respond_to?(:find) ? find(id:) : model.find(id)
          if instance.nil? ||
            !instance.respond_to?(:account) ||
            (instance.account.id != account.id && !account.admin)
              false
          else
            respond_to?(:delete) ? delete(instance) : instance.delete
          end
        end
      end
    end
  end
end
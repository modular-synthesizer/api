module Modusynth
  module Services
    module Concerns
      module Deleter
        extend ActiveSupport::Concern

        # Tries to find a record, and if found, removes it from the database. This depends
        # On the service implementing the Concerns::Finder class o be able to find the
        # record before deleting it. If the record is not found, it will NOT raise an error
        # as the controllers are NOT supposed to return 404 when a record is not found.
        def remove(id:, **_)
          unless respond_to? :model, true
            raise Modusynth::Exceptions::Concern.new(
              caller: 'delete',
              called: 'model'
            )
          end
          instance = model.find(id)
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

        def remove_all(items)
          items.each do |item|
            if item.is_a? String
              remove id: item
            elsif item.respond_to? :id
              remove id: item.id.to_s
            end
          end
        end
      end
    end
  end
end
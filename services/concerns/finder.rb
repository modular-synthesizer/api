module Modusynth
  module Services
    module Concerns
      # A finder service is a service that provide methods to find an
      # instance of the associated model. If the :model method is NOT
      # defined when invoking one of its methods, it will therefore
      # raise an error to indicate you did not implement everything you
      # needed to use this concern.
      #
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      module Finder
        extend ActiveSupport::Concern

        # Tries to find a group given its unique identifier. If it does not
        # find it, fails with a correct esception raised. If the model
        # method is not implemented raises an error to indicate you're not
        # implementing the concern correctly.
        #
        # @param id [string] the unique identifier of the group to find.
        # @raise [::Modusynth::Exceptions::Unknown] when the UUID is not
        #   found in the database.
        # @raise [::Modusynth::Exceptions::Concern] when the concern is not
        #   correctly implemented
        def find_or_fail(id: nil, field: 'id')
          instance = find(id: id)
          raise Modusynth::Exceptions.unknown(field) if instance.nil?
          instance
        end

        def find(id:)
          unless respond_to? :model, true
            raise Modusynth::Exceptions::Concern.new(
              caller: 'find_or_fail',
              called: 'model'
            )
          end
          model.where(id: id).first
        end
      end
    end
  end
end
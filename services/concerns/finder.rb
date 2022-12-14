module Modusynth
  module Services
    module Concerns
      # A finder service is a service that provide methods to find one or
      # several instances of the associated model. If the :model method is
      # NOT defined when invoking one of its methods, it will therefore
      # raise an error to indicate you did not implement everything you
      # needed to use this concern.
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
        def find_or_fail(id:)
          unless respond_to? :model, true
            raise Modusynth::Exceptions::Concern.new(
              caller: 'find_or_fail',
              called: 'model'
            )
          end
          instance = model.where(id: id).first
          raise Modusynth::Exceptions.unknown if instance.nil?
          instance
        end
      end
    end
  end
end
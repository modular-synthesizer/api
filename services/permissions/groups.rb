module Modusynth
  module Services
    module Permissions
      # Service to administrate the groups (creation, deletion, membership).
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Group
        include Singleton

        # Creates the group given the corresponding slug.
        # @param slug [string] the slug for the group to create, see the
        #   model class for the correct format to give the slug.
        # @return [Modusynth::Models::Permissions::Group] the created model.
        def create(slug:)

        end

        # Deletes the corresponding group after searching for its UUID.
        # @param id [string] the unique UUID of the group to delete.
        # @return [Boolean] TRUE if the model has been deleted.
        def delete(id:)
          find_or_fail(id: id).delete
        end

        # Tries to find a group given its unique identifier. If it does not
        # find it, fails with a correct esception raised.
        # @param id [string] the unique identifier of the group to find.
        # @raise [::Modusynth::Exceptions::Unknown] when the UUID is not
        #   found in the database.
        def find_or_fail(id:)
          instance = model.where(id: id).first
          raise Modusynth::Exceptions.unknown if instance.nil?
          instance
        end

        private

        def models
          Modusynth::Models::Permissions::Group
        end
      end
    end
  end
end
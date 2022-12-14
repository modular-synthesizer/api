module Modusynth
  module Services
    module Permissions
      # Service to administrate the groups (creation, deletion, membership).
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Groups
        include Singleton
        include Modusynth::Services::Concerns::Finder

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

        private

        def model
          Modusynth::Models::Permissions::Group
        end
      end
    end
  end
end
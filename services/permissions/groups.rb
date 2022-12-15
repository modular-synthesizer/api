module Modusynth
  module Services
    module Permissions
      # Service to administrate the groups (creation, deletion, membership).
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Groups
        include Singleton
        include Modusynth::Services::Concerns::Finder
        include Modusynth::Services::Concerns::Deleter

        # Creates the group given the corresponding slug.
        # @param slug [string] the slug for the group to create, see the
        #   model class for the correct format to give the slug.
        # @return [Modusynth::Models::Permissions::Group] the created model.
        def create(slug:, scopes: [])
          group = Modusynth::Models::Permissions::Group.new(
            slug: slug,
            scopes: find_scopes(ids: scopes)
          )
          group.save!
          group
        end

        def list
          model.all.sort(slug: 1).to_a
        end

        def update payload
          payload = payload.slice(:id, :scopes, :slug)
          instance = find_or_fail(id: payload[:id])
          instance.update_attributes(**payload)
          instance.save!
          instance
        end

        private

        def find_scopes ids:
          ids.map do |id|
            Modusynth::Services::Permissions::Scopes.instance.find_or_fail(id: id)
          end
        end

        def model
          Modusynth::Models::Permissions::Group
        end
      end
    end
  end
end
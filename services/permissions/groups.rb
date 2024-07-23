module Modusynth
  module Services
    module Permissions
      # Service to administrate the groups (creation, deletion, membership).
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Groups < Modusynth::Services::Base
        include Singleton

        def build(slug: nil, is_default: false, scopes: [], **_)
          model.new(slug:, is_default:, scopes: find_scopes(ids: scopes))
        end

        def list
          super.sort(slug: 1).to_a
        end

        def update group, payload
          attrs = payload.slice(:id, :scopes, :slug, :is_default)
          if attrs[:scopes].kind_of? Array
            attrs[:scopes] = find_scopes(ids: attrs[:scopes])
          end
          group.update_attributes(**attrs)
          group
        end

        def find_scopes ids:
          ids.map.with_index do |id, index|
            Modusynth::Services::Permissions::Rights.instance.find_or_fail(id: id, field: "scopes[#{index}]")
          end
        end

        def model
          Modusynth::Models::Permissions::Group
        end
      end
    end
  end
end
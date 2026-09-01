module Modusynth
  module Services
    module Blueprints
      class Find
        include Singleton
        include Modusynth::Services::Concerns::Finder

        def model
          Modusynth::Models::Blueprints::Blueprint
        end

        def list session: nil, **_
          criteria = can_see_experimentals(session:) ? {} : { experimental: false }
          do_list(**criteria)
        end

        def find_by_ids(ids: [], **_)
          Modusynth::Models::Blueprints::Blueprint
            .includes(:ports, :parameters, :controls)
            .where(:id.in => ids)
        end

        def find_if_allowed id: nil, session:, **_
          blueprint = find_or_fail(id:)
          if blueprint.experimental && can_see_experimentals(session:)
            raise Modusynth::Exception.forbidden('auth_token')
          end
          blueprint
        end

        private

        def can_see_experimentals session:, **_
          rights_service.has_right(session:, right: Rights::TOOLS_EXP)
        end

        def rights_service
          Modusynth::Services::Permissions::Rights.instance
        end
      end
    end
  end
end
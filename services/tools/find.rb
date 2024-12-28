module Modusynth
  module Services
    module Tools
      class Find
        include Singleton
        include Modusynth::Services::Concerns::Finder

        def model
          Modusynth::Models::Tool
        end

        def list session: nil, **_
          criteria = can_see_experimentals(session:) ? {} : { experimental: false }
          do_list(**criteria)
        end

        def find_if_allowed id: nil, session:, **_
          tool = find_or_fail(id:)
          if tool.experimental && can_see_experimentals(session:)
            raise Modusynth::Exception.forbidden('auth_token')
          end
          tool
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
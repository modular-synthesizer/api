module Modusynth
  module Services
    module Permissions
      class Rights < Modusynth::Services::Base
        include Singleton

        def build label: nil, **_
          model.new(label:)
        end

        def list
          super.sort(label: 1).to_a
        end

        def for_session session
          session.account.all_groups.map(&:scopes).flatten.uniq
        end

        def has_right session: nil, right: ''
          for_session(session).map(&:label).include?(right)
        end

        def model
          Modusynth::Models::Permissions::Right
        end
      end
    end
  end
end
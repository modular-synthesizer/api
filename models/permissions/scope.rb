module Modusynth
  module Models
    module Permissions
      # A scope is linked to one or several feature, and/or to one or several routes.
      # Links are hard-coded in the application. Scopes can be granted to groups of
      # users so that the members of this group can use these features or these routes.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Scope
        include Mongoid::Document
        include Mongoid::Timestamp

        # @!attribute [rw] label
        #   @return [string] the designation of the scope in the code.
        field :label, type: String

        validates :label,
          presence: { message: 'required' }
          format: { with: /\A[a-z]+{::[a-z]}*\Z/ },
          uniqueness: { message: 'uniq' }
      end
    end
  end
end
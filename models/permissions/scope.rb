module Modusynth
  module Models
    module Permissions
      # A scope is linked to one or several feature, and/or to one or several routes.
      # Links are hard-coded in the application. Scopes can be granted to groups of
      # users so that the members of this group can use these features or these routes.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Scope
        include Mongoid::Document
        include Mongoid::Timestamps

        # @!attribute [rw] label
        #   @return [string] the designation of the scope in the code.
        field :label, type: String

        # @!attribute [rw] groups
        #   @return [Iterable] the groups this scope has been granted to.
        has_and_belongs_to_many :groups,
          class_name: '::Modusynth::Models::Permissions::Group',
          inverse_of: :scopes

        validates :label,
          presence: { message: 'required' },
          format: { with: /\A[A-Z]?[a-z_]+(::[A-Z]?[a-z_]+)*\Z/, message: 'format', if: :label? },
          length: { minimum: 5, message: 'minlength', if: :label? },
          uniqueness: { message: 'uniq', if: :label? }
      end
    end
  end
end
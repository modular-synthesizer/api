module Modusynth
  module Models
    module Permissions
      # A group gathers a bunch of people so that they all have the same rights to access
      # routes and features throughout the application. A group is linked to a bunche of
      # scopes that give access to features when they are hardcoded in the application.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Group
        include Mongoid::Document
        include Mongoid::Timestamps

        # @!attribute [rw] slug
        #   @return [string] the uniq slug to identify the group.
        field :slug, type: String

        # @!attribute [rw] scopes
        #   @return [Iterable] the scopes this group can access through the application.
        has_and_belongs_to_many :scopes,
          class_name: '::Modusynth::Models::Permissions::Scope',
          inverse_of: :groups

        validates :slug,
          presence: { message: 'required' },
          format: { with: /\A[a-z]+(\-[a-z]+)*\Z/, message: 'format', if: :slug? },
          length: { minimum: 5, message: 'minlength', if: :slug? },
          uniqueness: { message: 'uniq' }
      end
    end
  end
end
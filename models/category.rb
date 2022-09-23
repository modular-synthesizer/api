module Modusynth
  module Models
    # A category is often a breand under which we place tools so that
    # we can split them in the interface and regroup them in likewise
    # categories for the user to not be over-crowded.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Category
      include Mongoid::Document

      field :name, type: String

      has_many :tools, class_name: '::Modusynth::Models::Tool', inverse_of: :category

      validates :name,
        presence: { message: 'required' },
        uniqueness: { message: 'uniq' },
        length: { message: 'length', minimum: 2, if: :name? },
        # The format is ONLY alphabetical characters as the name will be used as
        # a translation key on the frontend side.
        format: { with: /\A[A-za-z]+\Z/, message: 'format' }
    end
  end
end
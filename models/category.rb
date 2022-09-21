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
    end
  end
end
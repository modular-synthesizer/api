module Modusynth
  module Models
    module Tools
      class InnerLinkEnd
        include Mongoid::Document

        field :node, type: String

        field :index, type: Integer

        validates :node,
          presence: { message: 'required' },
          length: { minimum: 3, if: :node? }
      end
    end
  end
end
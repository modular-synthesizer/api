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
        
        validates :index,
          numericality: { greater_than: -1, message: 'value' }
      end
    end
  end
end
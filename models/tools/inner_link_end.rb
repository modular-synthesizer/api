module Modusynth
  module Models
    module Tools
      class InnerLinkEnd
        include Mongoid::Document

        field :node, type: String

        field :index, type: Integer
      end
    end
  end
end
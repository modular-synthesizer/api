module Modusynth
  module Models
    module Tools
      class Port
        include Mongoid::Document

        field :node, type: String

        field :index, type: Integer
        
        field :label, type: String
      end
    end
  end
end
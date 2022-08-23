module Modusynth
  module Models
    module Tools
      # The representation of one of the Web Audio API node embedded
      # inside a module in a synthesizer. The type show how it will
      # be created by the frontend part.
      class InnerNode
        include Mongoid::Document

        field :name, type: String

        field :type, type: String

        field :payload, type: Hash
      end
    end
  end
end
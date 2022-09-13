module Modusynth
  module Models
    module Tools
      class Port
        include Mongoid::Document

        field :name, type: String

        field :targets, type: Array

        field :index, type: Integer

        validates :name,
          presence: { message: 'required' },
          length: { minimum: 3, message: 'length' }
        
        validates :index,
          numericality: { minimum: 0, message: 'value' }
      end
    end
  end
end
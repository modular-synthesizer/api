module Modusynth
  module Models
    module Tools
      class Port
        include Mongoid::Document

        field :name, type: String

        field :targets, type: Array

        field :index, type: Integer, default: 0

        validates :name,
          presence: { message: 'required' },
          length: { minimum: 3, message: 'length', if: :name? }
        
        validates :index,
          numericality: { greater_than: 0, message: 'value', if: :index? }
      end
    end
  end
end
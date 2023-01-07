module Modusynth
  module Models
    module Tools
      class Port
        include Mongoid::Document

        store_in collection: 'tools_ports'

        field :kind, type: String

        field :name, type: String

        field :target, type: String

        field :index, type: Integer, default: 0

        validates :name,
          presence: { message: 'required' },
          length: { minimum: 3, message: 'length', if: :name? }
        
        validates :index,
          presence: { message: 'required' },
          numericality: { greater_than: -1, message: 'value', if: :index? }

        scope :inputs, ->{ where(kind: 'input') }

        scope :outputs, ->{ where(kind: 'output') }
      end
    end
  end
end
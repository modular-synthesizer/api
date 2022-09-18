module Modusynth
  module Models
    module Tools
      class Port
        include Mongoid::Document

        field :kind, type: String

        field :name, type: String

        field :targets, type: Array

        field :index, type: Integer, default: 0

        belongs_to :tool, class_name: '::Modusynth::Models::Tool', inverse_of: :ports

        validates :name,
          presence: { message: 'required' },
          length: { minimum: 3, message: 'length', if: :name? }
        
        validates :index,
          numericality: { greater_than: -1, message: 'value', if: :index? }

        scope :inputs, ->{ where(kind: 'input') }

        scope :outputs, ->{ where(kind: 'output') }
      end
    end
  end
end
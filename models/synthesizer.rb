module Modusynth
  module Models
    # A synthesizer is the base object of the business in our application. It creates one of the
    # interfaces where a user can create nodes and connect them to sculpt sound and produce
    # music.
    # @ author Vincent Courtois <courtois.vincent@outlook.com>
    class Synthesizer
      include Mongoid::Document
      include Mongoid::Timestamps

      field :name, type: String

      has_many :modules, class_name: '::Modusynth::Models::Module', inverse_of: :synthesizer

      validates :name,
        presence: { message: 'required' },
        length: { minimum: 6, message: 'length'}
    end
  end
end
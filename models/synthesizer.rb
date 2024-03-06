module Modusynth
  module Models
    # A synthesizer is the base object of the business in our application. It creates one of the
    # interfaces where a user can create nodes and connect them to sculpt sound and produce
    # music.
    # @ author Vincent Courtois <courtois.vincent@outlook.com>
    class Synthesizer
      include Mongoid::Document
      include Mongoid::Timestamps

      store_in collection: 'synthesizers'

      field :name, type: String

      # @!attribute [rw] voices
      #  @return [Integer] the number of polyphony voices in the synthesizer, 1 means it's monophonic.
      field :voices, type: Integer, default: 1

      has_many :modules, class_name: '::Modusynth::Models::Module', inverse_of: :synthesizer

      has_many :links, class_name: '::Modusynth::Models::Link', inverse_of: :synthesizer

      # belongs_to :account, class_name: '::Modusynth::Models::Account', inverse_of: :synthesizers
      has_many :memberships, class_name: '::Modusynth::Models::Social::Membership', inverse_of: :synthesizer

      validates :name,
        presence: { message: 'required' },
        length: { minimum: 6, message: 'length'}
      
      validates :voices,
        numericality: { greater_than: 0, less_than: 257, message: 'value' }

      def creator
        memberships.where(enum_type: 'creator').first
      end

      def guests
        memberships.where(:enum_type.ne => 'creator').to_a
      end

      def guest account:
        memberships.where(account:).first
      end
    end
  end
end
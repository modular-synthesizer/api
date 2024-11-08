# frozen_string_literal: true

module Modusynth
  module Models
    module Social
      # A membership defines the status of a user vis-a-vis a synthesizer, if it has been accepted or not,
      # if it can modify it or not, or if it is the owner (creator) of the synthesizer.
      #
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Membership
        include Mongoid::Document
        include Mongoid::Timestamps
        include ::Modusynth::Models::Concerns::Enumerable
        include ::Modusynth::Models::Concerns::Deletable

        store_in collection: 'synthesizer_memberships'

        # @!attribute [rw] x
        #   @return [Integer] the number of pixel between the left of the synth and the left of the screen.
        field :x, type: Integer, default: 0
        # @!attribute [rw] x
        #   @return [Integer] the number of pixel between the top of the synth and the top of the screen.
        field :y, type: Integer, default: 0
        # @!attribute [rw] scale
        #   @return [Float] the level of zoom (higher = more zoomed) for the synthesizer.
        field :scale, type: Float, default: 1.0

        enum_field :type, %w[read write creator], default: 'read'

        belongs_to :account, class_name: '::Modusynth::Models::Account', inverse_of: :memberships

        belongs_to :synthesizer, class_name: '::Modusynth::Models::Synthesizer', inverse_of: :memberships

        validates :scale,
                  numericality: { greater_than: 0, message: 'value' }

        scope :deleted, -> { where(:deleted_at.ne => nil) }
      end
    end
  end
end

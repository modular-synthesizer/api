module Modusynth
  module Models
    # An audio processor represents the content of an AudioWorkletProcessor in the web audio API, capoable of
    # processing audio signals and creating completely custom nodes. As they will be executed in a typescript
    # environment, typescript is adviced but the use of plain javascript is still possible
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class AudioProcessor
      include Mongoid::Document
      include Mongoid::Timestamps

      store_in collection: 'audio_processors'

      # @!attribute [rw] url
      #   @return [String] the universal resource locator where the processor can be found.
      field :url, type: String
      # @!attribute [rw] public
      #   @return [Boolean] TRUE to allow other users to use the processor too, FALSE otherwise.
      field :public, type: Boolean, default: false

      # @!attribute [rw] account
      #   @return [Account] the creator of the processor.
      belongs_to :account, class_name: '::Modusynth::Models::Account', inverse_of: :audio_processors

      validates :url,
        presence: { message: 'required' },
        format: {
          with: /\Ahttps?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)\z/,
          message: 'format',
          if: :url?
        }
    end
  end
end
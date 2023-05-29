module Modusynth
  module Models
    # An audio processor represents the content of an AudioWorkletProcessor in the web audio API, capoable of
    # processing audio signals and creating completely custom nodes. As they will be executed in a typescript
    # environment, typescript is adviced but the use of plain javascript is still possible
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class AudioProcessor
      include Mongoid::Document
      include Mongoid::Timestamps

      # @!attribute [rw] process_function
      #   @return [String] the code content of the process function.
      field :process_function, type: String
      # @!attribute [rw] registration_name
      #   @return [String] the UNIQ name passed to the registerProcessor function, used to infer class name.
      field :registration_name, type: String
      # @!attribute [rw] public
      #   @return [Boolean] TRUE to allow other users to use the processor too, FALSE otherwise.
      field :public, type: String, default: false

      # @!attribute [rw] account
      #   @return [Account] the creator of the processor.
      belongs_to :account, class_name: '::Modusynth::Models::Account', inverse_of: :audio_processors

      validates :process_function,
        presence: { message: 'required' }

      validates :registration_name,
        presence: { message: 'required' },
        uniqueness: { message: 'uniq', if: :registration_name? },
        format: { with: /\A([a-z]+\-)*[a-z]+\Z/, message: 'format', if: :registration_name? }
    end
  end
end
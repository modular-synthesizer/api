# frozen_string_literal: true

module Modusynth
  module Models
    module Concerns
      module Deletable
        extend ActiveSupport::Concern

        included do
          # @!attribute [rw] deleted_at
          #   @return [DateTime] the date and time at which the document has been deleted, or nil.
          field :deleted_at, type: DateTime, default: nil

          # @!attribute [rw] deleted_by
          #   @return [Modusynth::Models::Account] the user that deleted the resource.
          #                                        Returns nil if has not been deleted.
          belongs_to :deleted_by, class_name: '::Modusynth::Models::Account', optional: true

          scope :deleted, -> { where(:deleted_at.ne => nil) }
        end

        def deleted?
          !deleted_at.nil?
        end
      end
    end
  end
end

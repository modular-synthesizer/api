# frozen_string_literal: true

module Modusynth
  module Models
    module Modules
      class Control
        include Mongoid::Document
        include Modusynth::Models::Concerns::Control

        store_in collection: 'controls'
      end
    end
  end
end

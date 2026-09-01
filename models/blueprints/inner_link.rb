# frozen_string_literal: true

module Modusynth
  module Models
    module Blueprints
      class InnerLink
        include Mongoid::Document

        embeds_one :from, class_name: 'Models::Blueprints::InnerLinkEnd'

        embeds_one :to, class_name: 'Models::Blueprints::InnerLinkEnd'

        embedded_in :blueprint, class_name: '::Modusynth::Models::Blueprints::Blueprint', inverse_of: :inner_links
      end
    end
  end
end

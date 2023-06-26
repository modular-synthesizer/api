module Modusynth
  module Models
    module Tools
      class InnerLink
        include Mongoid::Document

        embeds_one :from, class_name: 'Models::Tools::InnerLinkEnd'

        embeds_one :to, class_name: 'Models::Tools::InnerLinkEnd'
        
        embedded_in :tool, class_name: '::Modusynth::Models::Tool', inverse_of: :inner_links
      end
    end
  end
end
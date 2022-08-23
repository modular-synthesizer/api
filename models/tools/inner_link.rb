module Modusynth
  module Models
    module Tools
      class InnerLink
        include Mongoid::Document

        embeds_one :from, class_name: 'Models::Tools::InnerLinkEnd'

        embeds_one :to, class_name: 'Models::Tools::InnerLinkEnd'
      end
    end
  end
end
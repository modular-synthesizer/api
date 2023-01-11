module Modusynth
  module Services
    class LinkEnds
      include Singleton
      include Modusynth::Services::Concerns::Creator

      def build node: nil, index: nil, **others
        Modusynth::Models::Tools::InnerLinkEnd.new(node:, index:)
      end

      def validate! node: nil, index: nil, **others
        build(node:, index:).validate!
      end
    end
  end
end

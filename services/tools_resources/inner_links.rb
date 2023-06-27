# frozen_string_literal: true

module Modusynth
  module Services
    module ToolsResources
      class InnerLinks < Modusynth::Services::Base
        include Singleton

        def build from: nil, to: nil, tool: nil, prefix: '', **_
          model.new(
            from: ends_service.build_and_validate!(**from, prefix: "#{prefix}.from"),
            to: ends_service.build_and_validate!(**to, prefix: "#{prefix}.to"),
            tool:
          )
        end

        def validate! prefix: '', **payload
          [:from, :to].each { |key| check_missing_end(payload:, key:, prefix:) }
          build(**payload).validate!
        end

        def check_missing_end payload:, key:, prefix: ''
          if payload[key].nil?
            raise Modusynth::Exceptions::Service.new(prefix:, error: 'required', key:)
          end
        end

        def ends_service
          InnerLinkEnds.instance
        end

        def model
          Modusynth::Models::Tools::InnerLink
        end
      end
    end
  end
end

# frozen_string_literal: true

module Modusynth
  module Models
    module Modules
      # This represents the value a module has given to a parameter declared in its tool descriptor.
      # The value will be replacing the web audio parameter targetted by the parameter when edited.
      # @author Vincent courtois <courtois.vincent@outlook.com>
      class Parameter
        include Mongoid::Document

        store_in collection: 'parameters'

        # @!attributes [rw] value
        #   @return [Float] the current value for this parameter.
        field :value, type: Float
        # @!attributes [rw] last_blocked_date
        #   @return [DateTime] the last date and time at which the param has been blocked (a user has started an edition)
        field :last_blocked_date, type: DateTime, default: nil

        # @!attributes [rw] template
        #   @return [Modusynth::Models::Tools::Parameter] the parameter template from which the parameter has been created.
        belongs_to :template, class_name: '::Modusynth::Models::Tools::Parameter', inverse_of: :instances
        # @!attributes [rw] module
        #   @return [Modusynth::Models::Module] the instanciated module in which this parameter is placed.
        belongs_to :module, class_name: '::Modusynth::Models::Module', inverse_of: :value

        belongs_to :blocker, class_name: '::Modusynth::Models::Account', optional: true

        def editable?
          blocker.nil? || last_blocked_date.nil? || (last_blocked_date + (30.0 / 86_400)) < DateTime.now
        end

        def editable_by?(account:)
          editable? || blocker.username == account.username
        end

        def name
          template.name
        end
      end
    end
  end
end

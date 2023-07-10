module Modusynth
  module Models
    # A module is what we called a "node" in ancient versions of the application.
    # It has one or several audio inputs, one or several audio outputs, and
    # transforms the sound via a set of voltage-controlled inputs or numeric
    # parameters that can change frequencies, gains, or any over value.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Module
      include Mongoid::Document
      include Mongoid::Timestamps

      store_in collection: 'modules'

      field :slot, type: Integer, default: 0

      field :rack, type: Integer, default: 0

      belongs_to :synthesizer, class_name: '::Modusynth::Models::Synthesizer', inverse_of: :modules

      belongs_to :tool, class_name: '::Modusynth::Models::Tool', inverse_of: :modules

      has_many :parameters, class_name: '::Modusynth::Models::Modules::Parameter', inverse_of: :module

      has_many :ports, class_name: '::Modusynth::Models::Modules::Port', inverse_of: :module

      def account
        synthesizer.account
      end

      # Instanciates all porst and parameters from the tool in the node.
      after_create do |document|
        document.tool.parameters.each do |parameter|
          document.parameters << Modusynth::Models::Modules::Parameter.new(
            template: parameter,
            value: parameter.default
          )
        end
        document.tool.ports.each do |port|
          document.ports << Modusynth::Models::Modules::Port.new(
            descriptor: port, module: document
          )
        end
      end

      def method_missing name, *args, &block
        if /[a-z_]+=/.match name
          parameter = parameters.where(name: name[0..-1]).first
          parameter.value = args[0] unless parameter.nil?
        else
          super
        end
      end
    end
  end
end
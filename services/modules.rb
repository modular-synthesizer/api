# rubocop:disable Metrics/AbcSize
# frozen_string_literal: true

module Modusynth
  module Services
    class Modules < Modusynth::Services::Base
      include Singleton

      def build synthesizer_id: nil, blueprint_id: nil, slot: 0, rack: 0, **_
        synthesizer = Modusynth::Services::Synthesizers.instance.find_or_fail(
          id: synthesizer_id,
          field: 'synthesizer_id'
        )
        blueprint = Modusynth::Services::Blueprints::Find.instance.find_by_ids(ids: [blueprint_id]).first
        instance = model.new(
          synthesizer:,
          blueprint:,
          slot:,
          rack:
        )
        instance.parameters = create_parameters_from(blueprint.parameters, instance)
        instance.ports = create_ports_from(blueprint.ports, instance)
        instance
      end

      def list(synthesizer_id:, **_)
        model
          .where(synthesizer_id:)
      end

      def create_parameters_from(parameter_templates, mod)
        parameter_templates.map do |template|
          param = Modusynth::Models::Modules::Parameter.new(
            targets: template.targets,
            name: template.name,
            field: template.field,
            default: template.default,
            minimum: template.minimum,
            maximum: template.maximum,
            value: template.default,
            precision: template.precision,
            step: template.step,
            module: mod
          )
          param
        end
      end

      def create_ports_from(port_templates, mod)
        port_templates.map do |template|
          param = Modusynth::Models::Modules::Port.new(
            target: template.target,
            kind: template.kind,
            name: template.name,
            index: template.index,
            module: mod
          )
          param
        end
      end

      def update id: nil, session: nil, **payload
        mod = find_or_fail(id:)
        membership = Memberships.instance.find_or_fail_by(session:, synthesizer: mod.synthesizer)
        raise Modusynth::Exceptions.forbidden('auth_token') if membership.nil? || membership.type_read?

        attributes = payload.slice(:slot, :rack)
        mod.update(**attributes)
        mod.save!
        mod
      end

      def delete(mod)
        ports_ids = mod.ports.map(&:id).map(&:to_s)
        Modusynth::Models::Link.where(:from.in => ports_ids).delete_all
        Modusynth::Models::Link.where(:to.in => ports_ids).delete_all
        mod.parameters.delete_all
        mod.ports.delete_all
        mod.delete
      end

      def remove(session:, id:, **_)
        mod = find(id:)
        return if mod.nil?

        membership = Memberships.instance.find_by(session:, synthesizer: mod.synthesizer)
        delete mod unless membership.nil? || membership.type_read?
        mod
      end

      def model
        Modusynth::Models::Module
      end

      # Finds the given modules by their respective IDs and
      def eager_load(synthesizer_id: nil, **_) # rubocop:disable Metrics/MethodLength
        mods = model
               .includes(:parameters, :ports)
               .where(synthesizer_id:)
               .to_a
        mods
      end
    end
  end
end

# rubocop:enable Metrics/AbcSize

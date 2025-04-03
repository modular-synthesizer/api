# rubocop:disable Metrics/AbcSize
# frozen_string_literal: true

module Modusynth
  module Services
    class Modules < Modusynth::Services::Base
      include Singleton

      def build synthesizer_id: nil, tool_id: nil, slot: 0, rack: 0, **_
        synthesizer = Modusynth::Services::Synthesizers.instance.find_or_fail(
          id: synthesizer_id,
          field: 'synthesizer_id'
        )
        tool = Modusynth::Services::Tools::Find.instance.find_or_fail(id: tool_id)
        model.new(synthesizer:, tool:, slot:, rack:)
      end

      def list(synthesizer_id:, **_)
        model
          .where(synthesizer_id:)
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
        tools = Modusynth::Models::Tool
                .includes(:parameters, :ports, :controls)
                .where(:id.in => mods.map(&:tool_id))
                .to_a
        mapped_tool_params = {}
        mapped_tool_ports = {}
        tools.each do |tool|
          tool.parameters.each do |tp|
            mapped_tool_params[tp.id] = tp
          end
          tool.ports.each do |tp|
            mapped_tool_ports[tp.id] = tp
          end
        end
        mods.each do |mod|
          mod.parameters.each do |p|
            p.template = mapped_tool_params[p.template_id]
          end
          mod.ports.each do |p|
            p.descriptor = mapped_tool_ports[p.descriptor_id]
          end
        end
        mods
      end
    end
  end
end

# rubocop:enable Metrics/AbcSize

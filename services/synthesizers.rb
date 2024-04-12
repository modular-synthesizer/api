module Modusynth
  module Services
    class Synthesizers < Modusynth::Services::Base
      include Singleton

      def list account, **payload
        query = { account: }
        if payload.has_key?(:type)
          if payload[:type].kind_of? Array
            query[:enum_type.in] = payload[:type]
          else
            query[:enum_type] = payload[:type]
          end
        end
        Modusynth::Models::Social::Membership.where(**query).to_a
      end

      def build account:, name: nil, voices: 1, **_
        instance = model.new(name:, voices:)
        instance.memberships << membership_model.new(account:, enum_type: 'creator')
        instance
      end

      def update synthesizer, **payload
        session = Modusynth::Services::Sessions.instance.find_or_fail(
          id: payload[:auth_token],
          field: 'auth_token'
        )
        if synthesizer.creator.account.id == session.account.id
          synthesizer.update(**payload.slice(:name, :racks, :slots, :voices))
          return synthesizer unless synthesizer.valid?
        end
        membership = synthesizer.memberships.where(account: session.account).first
        unless membership.nil?
          membership.update!(**payload.slice(:x, :y, :scale))
        end
        synthesizer
      end

      # Creates an invitation for the given user in the given synthesizer if they are both found.
      # If the status is invalid, the invitation is created with only the READ permissions.
      def add_user id: nil, session_id: nil, type: 'read'
        synthesizer = find_or_fail(id:)
        session = Modusynth::Services::Sessions.instance.find_or_fail(id: session_id)

        Modusynth::Models::Social::Membership.create(
          account: session.account, synthesizer:, type:
        )
      end

      def remove id: nil, session: nil, **_
        synthesizer = find(id:)
        return if synthesizer.nil?
        membership = Memberships.instance.find_by(session:, synthesizer:)
        unless membership.nil? or membership.type_read?
          synthesizer.modules.each do |mod|
            Modusynth::Services::Modules.instance.remove(session:, id: mod.id)
          end
          synthesizer.memberships.each { |m| m.delete }
          synthesizer.delete
        end
      end

      def model
        Modusynth::Models::Synthesizer
      end

      def membership_model
        Modusynth::Models::Social::Membership
      end
    end
  end
end
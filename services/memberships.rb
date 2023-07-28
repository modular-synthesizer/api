module Modusynth
  module Services
    class Memberships < Modusynth::Services::Base
      include Singleton

      def build(session: nil, synthesizer_id: nil, account_id: nil, type: 'read', **_)
        synthesizer = Synthesizers.instance.find_or_fail(id: synthesizer_id, field: 'synthesizer_id')
        if session.nil? or !synthesizer.memberships.where(account: session.account, enum_type: 'creator').exists?
          raise Modusynth::Exceptions.forbidden('auth_token')
        end
        account = Accounts.instance.find_or_fail(id: account_id, field: 'account_id')
        if account.memberships.where(synthesizer:).exists?
          raise Modusynth::Exceptions::BadRequest.new('account_id', 'uniq')
        end
        unless ['read', 'write'].include?(type)
          raise Modusynth::Exceptions::BadRequest.new('type', 'value')
        end
        model.new(synthesizer:, account:, enum_type: type, x: 0, y: 0, scale: 1.0)
      end

      def validate!(session: nil, synthesizer_id: nil, account_id: nil, type: 'read', **_)
        membership = build(session:, synthesizer_id:, account_id:, type:)
        membership.validate!
        membership
      end

      def find_or_fail_by synthesizer: nil, session: nil, **_
        membership = find_by(synthesizer:, session:)
        raise Modusynth::Exceptions.forbidden('auth_token') if membership.nil?
        membership
      end

      def find_by synthesizer: nil, session: nil, **_
        Modusynth::Models::Social::Membership.where(synthesizer:, account: session.account).first
      end

      def model
        Modusynth::Models::Social::Membership
      end
    end
  end
end
module Modusynth
  module Services
    class Accounts < Modusynth::Services::Base
      include Singleton

      def search session:, query: '', **_
        return [] if query.size < 3
        return model.where(username: /#{query}/).limit(10).to_a
      end

      def build username: nil, email: nil, password: nil, password_confirmation: nil, **rest
        model.new(username:, email:, password:, password_confirmation:)
      end

      def authenticate username, password
        account = find_or_fail_username username
        raise Modusynth::Exceptions.required 'password' if password.nil?
        raise Modusynth::Exceptions.forbidden 'username' unless account.authenticate(password)
        account
      end

      def find_or_fail_username username
        raise Modusynth::Exceptions.required 'username' if username.nil?
        account = model.where(username: username).first
        raise Modusynth::Exceptions.unknown 'username' if account.nil?
        account
      end

      def update instance, **payload
        if payload[:groups].is_a? Array
          instance.groups = payload[:groups].map.with_index do |group, index|
            Permissions::Groups.instance.find_or_fail(id: group[:id], field: "groups[#{index}].id")
          end
        end
        instance
      end

      def update account, session: nil, **payload
        requester = session.account
        raise Modusynth::Exceptions.forbidden if requester != account && !requester.admin
        account.update(payload.slice(:sample_rate))
        account
      end

      def find_and_update_groups id: nil, groups: [], **_
        find_and_update(id:, groups:)
      end

      def model
        Modusynth::Models::Account
      end
    end
  end
end
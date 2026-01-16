# frozen_string_literal: true

module Modusynth
  module Services
    class Accounts < Modusynth::Services::Base
      include Singleton

      def search query: '', **_
        return [] if query.size < 3

        model.where(username: /#{query}/).limit(10).to_a
      end

      def build username: nil, email: nil, password: nil, password_confirmation: nil, **_
        model.new(username:, email:, password:, password_confirmation:)
      end

      def authenticate(username, password)
        account = find_or_fail_by(username:)
        raise Modusynth::Exceptions.forbidden 'username' unless account.authenticate(password)

        account
      end

      def model
        Modusynth::Models::Account
      end
    end
  end
end

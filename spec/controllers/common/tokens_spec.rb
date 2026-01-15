# frozen_string_literal: true

class TestTokensController < Modusynth::Controllers::Base
  new_route 'get', '/' do
    halt 204
  end
end

RSpec.describe 'Token authentication' do
  def app
    TestTokensController
  end

  let!(:account) { create(:babausse, jwt_secret: 'super_secret') }
  let!(:auth_token) do
    Modusynth::Services::Tokens.instance.create(username: 'babausse', password: account.password)[:jwt_token]
  end

  describe 'Nominal case' do
    it 'Returns a 204 (No Content) status code' do
      get '/', { auth_token:, account_id: account.id.to_s }
      expect(last_response.status).to be 204
    end
  end

  include_examples 'authentication', 'GET /'
end

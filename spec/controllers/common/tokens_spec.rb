# frozen_string_literal: true

class TestTokensController < Modusynth::Controllers::Base
  new_route 'get', '/' do
    halt 204
  end
end

RSpec.describe 'Token authentication' do # rubocop:disable Metrics/BlockLength
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
  describe 'Exception case : when the token is invalid' do
    before do
      get '/', { auth_token: 'test_invalid_token', account_id: account.id.to_s }
    end
    it 'Returns a 403 (Forbidden) status code' do
      expect(last_response.status).to be 403
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(key: 'account_id', message: 'forbidden')
    end
  end
  describe 'Exception case : when the user UUID does not match the token' do
    before do
      get '/', { auth_token:, account_id: 'other_account_id' }
    end
    it 'Returns a 403 (Forbidden) status code' do
      expect(last_response.status).to be 403
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(key: 'account_id', message: 'forbidden')
    end
  end
  describe 'When the token is expired' do
    before do
      allow(Time).to receive(:now).and_return(Time.at(0))
    end
  end
  describe 'When the token has been refreshed' do
    before do
      Modusynth::Models::Token.first.update_attributes(refreshed_at: DateTime.now)
      get '/', { auth_token:, account_id: account.id.to_s }
    end
    it 'Returns a 403 (Forbidden) status code' do
      expect(last_response.status).to be 403
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(key: 'account_id', message: 'forbidden')
    end
  end
  describe 'When the token has been invalidated' do
    before do
      Modusynth::Models::Token.first.update_attributes(invalidated_at: DateTime.now)
      get '/', { auth_token:, account_id: account.id.to_s }
    end
    it 'Returns a 403 (Forbidden) status code' do
      expect(last_response.status).to be 403
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(key: 'account_id', message: 'forbidden')
    end
  end
end

# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

RSpec.shared_examples 'authentication' do |route|
  def make_request(uuid, verb, path, payload = {})
    if %w[get delete].include? verb
      send(verb, "/#{uuid}#{path}", payload)
    else
      send(verb, "/#{uuid}#{path}", payload.to_json)
    end
  end

  describe 'Authentication errors' do
    let!(:account) { create(:babausse, jwt_secret: 'super_secret') }
    let!(:account_id) { account.uuid }
    let!(:auth_token) { create_token(account) }

    let!(:verb) { route.split[0].downcase }
    let!(:path) { route.split[1] }

    describe 'Authentication error : the auth token is not given' do
      before do
        make_request(account.uuid, verb, path, {})
      end
      it 'Returns a 400 (Bad request) status code' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'account_id', message: 'forbidden'
        )
      end
    end

    describe 'Authentication error : the token is invalid' do
      before do
        make_request account.uuid, verb, path, { auth_token: 'test_invalid_token', account_id: }
      end
      it 'Returns a 403 (Forbidden) status code' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(key: 'account_id', message: 'forbidden')
      end
    end

    describe 'Authentication error : the user UUID does not match the token' do
      before do
        make_request 'invalid-uuid', verb, path, { auth_token: }
      end
      it 'Returns a 403 (Forbidden) status code' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(key: 'account_id', message: 'forbidden')
      end
    end

    describe 'Authentication error : the token is expired' do
      before do
        allow(Modusynth::Services::Tokens.instance).to receive(:ten_minutes_from_now).and_return(600)
        make_request account.uuid, verb, path, { auth_token: create_token(account), account_id: }
      end
      it 'Returns a 403 (Forbidden) status code' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(key: 'account_id', message: 'forbidden')
      end
    end

    describe 'Authentication error : the token has been refreshed' do
      before do
        Modusynth::Models::Token.first.update_attributes(refreshed_at: DateTime.now)
        make_request account.uuid, verb, path, { auth_token:, account_id: }
      end
      it 'Returns a 403 (Forbidden) status code' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(key: 'account_id', message: 'forbidden')
      end
    end

    describe 'Authentication error : the token has been invalidated' do
      before do
        Modusynth::Models::Token.first.update_attributes(invalidated_at: DateTime.now)
        make_request account.uuid, verb, path, { auth_token:, account_id: }
      end
      it 'Returns a 403 (Forbidden) status code' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(key: 'account_id', message: 'forbidden')
      end
    end

    describe 'Authentication Error : the user has no permissions to access the route' do
      let!(:account) { create(:authenticator, uuid: 'auth-uuid') }
      let!(:auth_token) { create_token(account) }
      before do
        make_request account.uuid, verb, path, { auth_token: }
      end
      it 'Returns a 403 (Forbidden) status code' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(key: 'account_id', message: 'forbidden')
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength

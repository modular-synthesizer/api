RSpec.shared_examples 'authentication' do |verb, path|
  let!(:authenticator) { create(:authenticator) }
  let!(:authenticator_session) { create(:session, account: authenticator) }

  def request(verb, path, payload = {})
    if ['get', 'delete'].include? verb
      send(verb, path, payload)
    else
      send(verb, path, payload.to_json)
    end
  end

  describe 'Authentication errors' do
    describe 'The authentication token is not given' do
      before do
        request(verb, path)
      end
      it 'Returns a 400 (Bad request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'auth_token', message: 'required'
        )
      end
    end
    describe 'The authentication token is not found' do
      before do
        request(verb, path, {auth_token: 'unknown'})
      end
      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'auth_token', message: 'unknown'
        )
      end
    end
    describe 'The authentication token is expired' do
      before do
        Modusynth::Services::Sessions.instance.delete(
          authenticator_session.token,
          authenticator_session
        )
        request(verb, path, {auth_token: authenticator_session.token})
      end
      it 'Returns a 403 (Forbidden) status code' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'auth_token', message: 'forbidden'
        )
      end
    end
  end
end
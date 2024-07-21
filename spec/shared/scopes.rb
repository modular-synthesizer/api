RSpec.shared_examples 'scopes' do |verb, path|

  let!(:forbidden_account) { create(:account) }
  let!(:forbidden_session) { create(:session, account: forbidden_account) }

  def request(verb, path, payload = {})
    if ['get', 'delete'].include? verb
      send(verb, path, payload)
    else
      send(verb, path, payload.to_json)
    end
  end

  describe 'Scopes errors' do
    describe "The user does not have the required scope to access the route #{verb.upcase} #{path}" do
      before do
        request(verb, path, { auth_token: forbidden_session.token })
      end
      it 'Returns a 403 (Forbidden) status code' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(key: 'auth_token', message: 'forbidden')
      end
    end
  end
end
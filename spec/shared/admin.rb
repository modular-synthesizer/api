RSpec.shared_examples 'admin' do |verb, path|
  describe 'Administration privileges errors' do

    let!(:account) { create(:account) }
    let!(:session) { create(:session, account: account) }

    before do
      send(verb, path, create_payload(verb, session))
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
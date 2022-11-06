RSpec.describe 'GET /sessions/:id' do
  def app
    Modusynth::Controllers::Sessions
  end

  let!(:account) { create(:account) }
  let!(:session) { create(:session, account: account) }

  describe 'Nominal case' do
    before do
      get "/#{session.token}", {auth_token: session.token}
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        token: session.token,
        account_id: account.id.to_s,
        username: account.username,
        email: account.email,
        admin: account.admin
      )
    end
  end

  include_examples 'authentication', 'get', "/anything"

  include_examples 'ownership', 'get', '/:id', :session, :token
end
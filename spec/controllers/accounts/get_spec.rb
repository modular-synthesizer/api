RSpec.describe 'GET /accounts/:id' do
  def app
    Modusynth::Controllers::Accounts
  end

  let!(:account) { create(:babausse) }

  let!(:admin) { create(:random_admin) }
  let!(:session) { create(:session, account: admin) }

  let!(:forbidden_user) { create(:account, admin: false) }
  let!(:forbidden_session) { create(:session, account: forbidden_user) }

  describe 'Nominal case' do
    before do
      get "/#{account.id.to_s}", {auth_token: session.token}
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        id: account.id.to_s,
        username: account.username,
        email: account.email
      )
    end
  end

  describe 'Error cases' do
    before do
      get "/#{account.id.to_s}", {auth_token: forbidden_session.token}
    end
    it 'Returns a 403 (Forbidden) status code' do
      expect(last_response.status).to be 403
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        key: 'auth_token',
        message: 'forbidden'
      )
    end
  end

  include_examples 'authentication', 'get', "/own"
  include_examples 'scopes', 'get', "/own"
end
RSpec.describe 'GET /accounts/:id' do
  def app
    Modusynth::Controllers::Accounts
  end

  let!(:account) { create(:account) }
  let!(:session) { create(:session, account: account) }

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

  include_examples 'authentication', 'get', "/anything"
end
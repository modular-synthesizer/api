RSpec.describe 'GET /accounts/:id' do
  def app
    Modusynth::Controllers::Accounts
  end

  let!(:account) { create(:babausse) }
  let!(:auth_token) do
    Modusynth::Services::Tokens.instance.create(username: 'babausse', password: account.password)[:jwt_token]
  end

  describe 'Nominal case' do
    before do
      get '/own', { auth_token:, account_id: account.id.to_s }
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

  include_examples 'authentication', 'GET /own'
end

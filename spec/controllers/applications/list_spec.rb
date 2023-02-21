RSpec.describe 'GET /applications' do

  def app
    Modusynth::Controllers::Applications
  end

  let!(:account) { create(:babausse, admin: true) }
  let!(:session) { create(:session, account:) }

  describe 'Nominal case' do
    let!(:application) { create(:application, account: account, name: 'Test App') }

    before do
      get '/', {auth_token: session.token}
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json([
        {id: application.id.to_s, name: application.name}
      ])
    end
  end
  describe 'Empty list' do
    before do
      get '/', {auth_token: session.token}
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json([])
    end
  end
end
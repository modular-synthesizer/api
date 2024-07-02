RSpec.describe 'GET /categories' do
  def app
    Modusynth::Controllers::Categories
  end

  let!(:account) { create(:babausse) }
  let!(:session) { create(:session, account: account) }

  describe 'Nominal case' do
    before do
      post '/', {name: 'testCategory', auth_token: session.token}.to_json
      get '/', {auth_token: session.token}
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json([
        {
          id: have_attributes(size: 24),
          name: 'testCategory'
        }
      ])
    end
  end
  describe 'Alternative cases' do
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

  include_examples 'authentication', 'get', '/'
  include_examples 'scopes', 'get', '/'
end
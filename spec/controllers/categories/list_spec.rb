RSpec.describe 'GET /categories' do
  def app
    Modusynth::Controllers::Categories
  end

  let!(:admin) { create(:random_admin) }
  let!(:admin_session) { create(:session, account: admin) }

  describe 'Nominal case' do
    before do
      post '/', {name: 'testCategory', auth_token: admin_session.token}.to_json
      get '/'
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
        get '/'
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json([])
      end
    end
  end
end
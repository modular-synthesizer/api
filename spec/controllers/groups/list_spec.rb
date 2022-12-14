RSpec.describe 'GET /groups' do
  def app
    Modusynth::Controllers::Groups.new
  end

  let!(:account) { create(:account) }
  let!(:session) { create(:session, account: account) }

  describe 'Nominal case' do
    let!(:group) { create(:group) }

    before do
      get '/', { auth_token: session.token }
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json([
        {
          id: group.id.to_s,
          slug: 'custom-slug',
          scopes: []
        }
      ])
    end
  end
  describe 'Alternative cases' do
    describe 'With an empty list' do
      before do
        get '/', { auth_token: session.token }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to eq '[]'
      end
    end
  end

  include_examples 'authentication', 'get', '/'
end
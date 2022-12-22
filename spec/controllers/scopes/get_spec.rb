RSpec.describe 'GET /scopes/:id' do
  def app
    Modusynth::Controllers::Scopes.new
  end

  let!(:account) { create(:account, admin: true) }
  let!(:session) { create(:session, account: account) }
  let!(:group) { create(:group, slug: 'test-get') }
  let!(:scope) { create(:scope, label: 'Test::Get', groups: [group]) }

  describe 'Nominal case' do
    before do
      get "/#{scope.id.to_s}", {auth_token: session.token}
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        id: scope.id.to_s,
        label: 'Test::Get',
        groups: [
          {id: group.id.to_s, slug: 'test-get'}
        ]
      )
    end
  end
  describe 'Error cases' do
    describe 'WHen the ID is not found' do
      before do
        get '/unknown', {auth_token: session.token}
      end
      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns a correct body' do
        expect(last_response.body).to include_json(
          key: 'id', message: 'unknown'
        )
      end
    end
  end

  include_examples 'admin', 'get', '/:id'
end
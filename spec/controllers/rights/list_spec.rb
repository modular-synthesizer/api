RSpec.describe 'GET /scopes' do
  def app
    Modusynth::Controllers::Rights.new
  end

  let!(:account) { create(:account, admin: true) }
  let!(:session) { create(:session, account: account) }
  let!(:first_scope) { create(:scope, label: 'Test::Bscope') }
  let!(:second_scope) { create(:scope, label: 'Test::Ascope') }

  describe 'Nominal case' do
    before do
      get '/', {auth_token: session.token}
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json([
        {id: second_scope.id.to_s, label: 'Test::Ascope'},
        {id: first_scope.id.to_s, label: 'Test::Bscope'}
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
        expect(last_response.body).to include_json []
      end
    end
  end
  include_examples 'admin', 'get', '/'
end
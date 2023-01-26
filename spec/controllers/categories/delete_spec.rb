RSpec.describe 'DELETE /categories' do
  def app
    Modusynth::Controllers::Categories
  end

  let!(:admin) { create(:random_admin) }
  let!(:admin_session) { create(:session, account: admin) }

  describe 'Nominal case' do
    before do
      post '/', {name: 'testCategory', auth_token: admin_session.token}.to_json
      delete "/#{JSON.parse(last_response.body)['id']}", {auth_token: admin_session.token}
    end
    it 'returns a 204 (No Content) status code' do
      expect(last_response.status).to be 204
    end
  end
  describe 'Alternative cases' do
    describe 'When the ategory ID does not exist' do
      before do
        delete '/unknown', {auth_token: admin_session.token}
      end
      it 'Returns a 204 (No Content) status code' do
        expect(last_response.status).to be 204
      end
    end
  end

  include_examples 'admin', 'delete', '/anything'
end
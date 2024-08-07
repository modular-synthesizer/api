RSpec.describe 'DELETE /scopes/:id' do
  def app
    Modusynth::Controllers::Rights.new
  end

  let!(:account) { create(:random_admin) }
  let!(:session) { create(:session, account: account) }
  let!(:scope) { create(:scope, label: 'Test::Deletion') }

  describe 'Nominal case' do
    before do
      delete "/#{scope.id.to_s}", {auth_token: session.token}
    end
    it 'Returns a 204 (No Content) status code' do
      expect(last_response.status).to be 204
    end
    it 'Has deleted the scope' do
      expect(Modusynth::Models::Permissions::Right.where(label: 'Test::Deletion').count).to be 0
    end
  end
  describe 'Alternative cases' do
    describe 'When the ID is not found' do
      before do
        delete '/unknown', {auth_token: session.token}
      end
      it 'Returns a 204 (Not Found) status code' do
        expect(last_response.status).to be 204
      end
    end
  end
  include_examples 'authentication', 'delete', '/:id'
  include_examples 'scopes', 'delete', '/:id'
end
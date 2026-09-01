RSpec.describe 'DELETE /blueprints/controls/:id' do
  def app
    Modusynth::Controllers::ToolsResources::Controls
  end
  
  let!(:account) { create(:random_admin) }
  let!(:session) { create(:session, account:) }
  let!(:category) { create(:dopefun) }
  let!(:blueprint) { create(:VCA, category:, experimental: false) }

  describe 'Nominal case' do
    before do
      delete "/#{blueprint.controls.first.id.to_s}", {
        auth_token: session.token
      }
    end
    it 'Returns a 204 (No Content) status code' do
      expect(last_response.status).to be 204
    end
    it 'Has deleted the control' do
      blueprint.reload
      expect(blueprint.controls.count).to be 0
    end
  end
  describe 'Alternative case' do
    before do
      delete '/unknown', { auth_token: session.token }
    end
    describe 'When the UUID is not found' do
      it 'Returns a 204 (No Content) status code' do
        expect(last_response.status).to be 204
      end
      it 'Has not deleted the control' do
        blueprint.reload
        expect(blueprint.controls.count).to be 1
      end
    end
  end
end
RSpec.describe 'DELETE /blueprints/controls/:id' do
  def app
    Modusynth::Controllers::Blueprints::Blueprints
  end
  
  let!(:account) { create(:random_admin) }
  let!(:session) { create(:session, account:) }
  let!(:category) { create(:dopefun) }
  let!(:blueprint) { create(:VCA, category:, experimental: false) }
  let!(:control) { blueprint.controls.first }

  describe 'Nominal case' do
    before do
      delete "/#{blueprint.id.to_s}/controls/#{control.id.to_s}", { auth_token: session.token }
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
    describe 'When the UUID is not found' do
      before do
      delete "/#{blueprint.id.to_s}/controls/unknown", { auth_token: session.token }
      end
      it 'Returns a 204 (No Content) status code' do
        expect(last_response.status).to be 204
      end
      it 'Has not deleted the control' do
        blueprint.reload
        expect(blueprint.controls.count).to be 1
      end
    end
    describe 'When the UUID of the blueprint is unknown' do
      before do
        delete "/unknown/controls/#{control.id.to_s}", { auth_token: session.token }
      end
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
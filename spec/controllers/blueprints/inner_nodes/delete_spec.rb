RSpec.describe 'DELETE /blueprints/nodes/:id' do
  def app
    Modusynth::Controllers::ToolsResources::InnerNodes
  end
  
  let!(:account) { create(:random_admin) }
  let!(:session) { create(:session, account:) }
  let!(:category) { create(:dopefun) }
  let!(:blueprint) { create(:VCA, category:, experimental: false) }
  let!(:node) { blueprint.inner_nodes.first }

  describe 'Nominal case' do
    before do
      delete "/#{node.id.to_s}", {
        auth_token: session.token,
        blueprint_id: blueprint.id.to_s
      }
    end
    it 'Returns a 204 (Not Content) status code' do
      expect(last_response.status).to be 204
    end
    it 'Has deleted the node' do
      blueprint.reload
      expect(blueprint.inner_nodes.where(id: node.id).count).to be 0
    end
  end
  describe 'Alternative cases' do
    before do
      delete '/unknown', {
        auth_token: session.token,
        blueprint_id: blueprint.id.to_s
      }
    end
    describe 'When the node is not found' do
      it 'Returns a 204 (Not Content) status code' do
        expect(last_response.status).to be 204
      end
      it 'Has not deleted the node' do
        expect(blueprint.inner_nodes.count).to be 2
      end
    end
  end
  describe 'Error cases' do
    describe 'Where the blueprint UUID is not given' do
      before do
        delete "/#{node.id.to_s}", { auth_token: session.token }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'blueprint_id', message: 'required'
        )
      end
    end
    describe 'When the blueprint is not found' do
      before do
        delete "/#{node.id.to_s}", {
          auth_token: session.token,
          blueprint_id: 'unknown'
        }
      end
      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'blueprint_id', message: 'unknown'
        )
      end
    end
  end
end
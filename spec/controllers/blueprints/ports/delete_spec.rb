RSpec.describe 'DELETE /blueprints/ports/:id' do
  def app
    Modusynth::Controllers::ToolsResources::Ports
  end

  let!(:account) { create(:random_admin) }
  let!(:session) { create(:session, account:) }
  let!(:category) { create(:dopefun) }
  let!(:blueprint) { create(:VCA, category:, experimental: false) }
  let!(:port) { blueprint.ports.first }
  let!(:synthesizer) { Modusynth::Services::Synthesizers.instance.create(account:, name: 'test synth') }
  let!(:mod) { create(:VCA_module, blueprint:, synthesizer:) }

  describe 'Nominal case' do
    let!(:link) { create(:link, from: mod.ports.first, to: mod.ports.last, synthesizer:) }

    before do
      delete "/#{port.id}", { auth_token: session.token, blueprint_id: blueprint.id.to_s }
      blueprint.reload
    end
    it 'Returns a 204 (No Content) status code' do
      expect(last_response.status).to be 204
    end
    it 'Has deleted the port' do
      expect(blueprint.ports.find_by(id: port.id)).to be_nil
    end
  end
  describe 'Alternative cases' do
    describe 'When the port is not found on the blueprint' do
      before do
        delete '/unknown', { auth_token: session.token, blueprint_id: blueprint.id.to_s }
        blueprint.reload
      end
      it 'Returns a 204 (No Content) status code' do
        expect(last_response.status).to be 204
      end
      it 'Has not deleted the port' do
        expect(blueprint.ports.find_by(id: port.id)).to_not be_nil
      end
    end
  end
end

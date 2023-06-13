RSpec.describe 'DELETE /:tool_id/ports/:id' do

  def app
    Modusynth::Controllers::ToolsResources::Ports
  end
  
  let!(:account) { create(:account, admin: true) }
  let!(:session) { create(:session, account:) }
  let!(:category) { create(:dopefun) }
  let!(:tool) { create(:VCA, category:, experimental: false) }
  let!(:port) { tool.ports.first }
  let!(:synthesizer) { create(:synthesizer, account:) }
  let!(:mod) { create(:module, tool:, synthesizer:) }

  describe 'Nominal case' do
    let!(:link) { create(:link, from: mod.ports.first, to: mod.ports.last, synthesizer:) }
    
    before do
      delete "/#{port.id.to_s}", { auth_token: session.token }
    end
    it 'Returns a 204 (No Content) status code' do
      expect(last_response.status).to be 204
    end
    it 'Has deleted the port' do
      expect(Modusynth::Models::Tools::Port.where(id: port.id).count).to be 0
    end
    it 'Has deleted the port in the associated modules' do
      expect(mod.ports.where(descriptor_id: port.id).count).to be 0
    end
    describe 'Links deletion' do
      it 'Has deleted every link targetting this port' do
        expect(Modusynth::Models::Link.count).to be 0
      end
    end
  end
  describe 'Alternative cases' do
    describe 'When the port is not found on the tool' do
      before do
        delete "/unknown", { auth_token: session.token }
      end
      it 'Returns a 204 (No Content) status code' do
        expect(last_response.status).to be 204
      end
      it 'Has not deleted the port' do
        expect(Modusynth::Models::Tools::Port.where(id: port.id).count).to be 1
      end
    end
    describe 'When the tool is not found' do
      before do
        delete "/unknown", { auth_token: session.token }
      end
      it 'Returns a 204 (No Content) status code' do
        expect(last_response.status).to be 204
      end
      it 'Has not deleted the port' do
        expect(Modusynth::Models::Tools::Port.where(id: port.id).count).to be 1
      end
    end
  end
end
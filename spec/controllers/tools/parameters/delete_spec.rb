RSpec.describe 'DELETE /tools/parameters/:id' do

  def app
    Modusynth::Controllers::ToolsResources::Parameters
  end
  
  let!(:account) { create(:account, admin: true) }
  let!(:session) { create(:session, account:) }
  let!(:category) { create(:dopefun) }
  let!(:tool) { create(:tool, category:, experimental: false) }
  let!(:parameter) { create(:frequency, tool:) }
  let!(:synthesizer) { Modusynth::Services::Synthesizers.instance.create(account:, name: 'test synth') }
  let!(:mod) { create(:module, tool:, synthesizer:) }

  describe 'Nominal case' do

    before do
      delete "/#{parameter.id.to_s}", { auth_token: session.token }
    end
    it 'Returns a 204 (No Content) status code' do
      expect(last_response.status).to be 204
    end
    it 'Has deleted the parameter' do
      expect(Modusynth::Models::Tools::Parameter.where(id: parameter.id).count).to be 0
    end
    it 'Has deleted the parameter in the associated modules' do
      expect(mod.parameters.where(parameter: parameter.id).count).to be 0
    end
  end
  describe 'Alternative cases' do
    describe 'When the parameter is not found on the tool' do
      before do
        delete "/unknown", { auth_token: session.token }
      end
      it 'Returns a 204 (No Content) status code' do
        expect(last_response.status).to be 204
      end
      it 'Has not deleted the port' do
        expect(Modusynth::Models::Tools::Parameter.where(id: parameter.id).count).to be 1
      end
    end
  end
end
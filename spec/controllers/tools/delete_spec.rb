RSpec.describe 'DELETE /tools/:id' do
  def app
    Modusynth::Controllers::Tools
  end

  let!(:account) { create(:babausse, admin: true) }
  let!(:session) { create(:session, account:) }
  let!(:dopefun) { create(:dopefun) }
  let!(:tool) { create(:VCA, category: dopefun) }
  let!(:synth) do
    Modusynth::Services::Synthesizers.instance.create(account:, name: 'test synth', racks: 2)
  end
  let!(:node) { create(:VCA_module, tool:, synthesizer: synth) }

  describe 'Nominal case' do
    before do
      delete "/#{tool.id.to_s}", { auth_token: session.token }
    end
    it 'Returns a 204 (No Content) status code' do
      expect(last_response.status).to be 204
    end
    it 'Has deleted the tool correctly' do
      expect(Modusynth::Models::Tool.all.count).to be 0
    end
    it 'Has deleted all the corresponding modules' do
      expect(Modusynth::Models::Module.all.count).to be 0
    end
  end
end
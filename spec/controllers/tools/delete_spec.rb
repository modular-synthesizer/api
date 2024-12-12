RSpec.describe Modusynth::Controllers::Tools do
  def app
    Modusynth::Controllers::Tools
  end

  describe 'DELETE /:id' do
    let!(:account) { create(:random_admin) }
    let!(:session) { create(:session, account: account) }
    let!(:dopefun) { create(:dopefun) }
    let!(:tool) { create(:VCA, category: dopefun) }

    describe 'Nominal case' do
      before do
        delete "/#{tool.id.to_s}", { auth_token: session.token }
      end

      it 'Returns a 204 (No Content) status code' do
        expect(last_response.status).to be 204
      end
      it 'Has correctly deleted the tool' do
        expect(Modusynth::Models::Tool.find(id: tool.id)).to be_nil
      end
    end
    describe 'Alternative cases' do
      let!(:synthesizer) { Modusynth::Services::Synthesizers.instance.create(account:, name: 'test synth') }
      let(:node) { create(:VCA_module, synthesizer: synthesizer) }

      before do
        delete "/#{tool.id.to_s}", { auth_token: session.token }
      end

      describe 'When a module has been created from the tool' do
        it 'Returns a 204 (No Content) status code' do
          expect(last_response.status).to be 204
        end
        it 'Has correctly deleted the tool' do
          expect(Modusynth::Models::Tool.find(id: tool.id)).to be_nil
        end
        it 'Has correctly deleted the module linked to it' do
          expect(Modusynth::Models::Module.find(id: tool.id)).to be_nil
        end
      end
    end
  end
end
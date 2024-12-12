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
        expect(Modusynth::Models::Tool.find_by(id: tool.id)).to be_nil
      end
    end
    describe 'Alternative cases' do
      describe 'When a module has been created from the tool' do
        let!(:synthesizer) { Modusynth::Services::Synthesizers.instance.create(account:, name: 'test synth') }
        let(:node) { create(:VCA_module, synthesizer: synthesizer) }
  
        before do
          delete "/#{tool.id.to_s}", { auth_token: session.token }
        end

        it 'Returns a 204 (No Content) status code' do
          expect(last_response.status).to be 204
        end
        it 'Has correctly deleted the tool' do
          expect(Modusynth::Models::Tool.find_by(id: tool.id)).to be_nil
        end
        it 'Has correctly deleted the module linked to it' do
          expect(Modusynth::Models::Module.find_by(id: tool.id)).to be_nil
        end
      end
      describe 'When the tool has a port' do
        let!(:input_port) { create(:input_port, tool:) }
        let!(:output_port) { create(:output_port, tool:) }

        before do
          delete "/#{tool.id.to_s}", { auth_token: session.token }
        end

        it 'Returns a 204 (No Content) Status code' do
          expect(last_response.status).to be 204
        end
        it 'Has correctly deleted the tool' do
          expect(Modusynth::Models::Tool.find_by(id: tool.id.to_s)).to be_nil
        end
        it 'Has correctly deleted the input port' do
          expect(Modusynth::Models::Tools::Port.find_by(id: input_port.id.to_s)).to be_nil
        end
        it 'Has correctly deleted the output port' do
          expect(Modusynth::Models::Tools::Port.find_by(id: output_port.id.to_s)).to be_nil
        end
      end
      describe 'When the tool has a parameter' do
        let!(:tool_parameter) { create(:tool_parameter, tool:) }

        before do
          delete "/#{tool.id.to_s}", { auth_token: session.token }
        end

        it 'Returns a 204 (No Content) Status code' do
          expect(last_response.status).to be 204
        end
        it 'Has correctly deleted the tool' do
          expect(Modusynth::Models::Tool.find_by(id: tool.id.to_s)).to be_nil
        end
        it 'Has correctly deleted the parameter' do
          expect(Modusynth::Models::Tools::Parameter.find_by(id: tool_parameter.id.to_s)).to be_nil
        end
      end
      describe 'When the tool has a control' do
        let!(:tool_control) { create(:tool_control, tool:) }

        before do
          delete "/#{tool.id.to_s}", { auth_token: session.token }
        end

        it 'Returns a 204 (No Content) Status code' do
          expect(last_response.status).to be 204
        end
        it 'Has correctly deleted the tool' do
          expect(Modusynth::Models::Tool.find_by(id: tool.id.to_s)).to be_nil
        end
        it 'Has correctly deleted the control' do
          expect(Modusynth::Models::Tools::Control.find_by(id: tool_control.id.to_s)).to be_nil
        end
      end
    end
  end
end
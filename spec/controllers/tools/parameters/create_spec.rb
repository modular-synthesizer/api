RSpec.describe 'POST /tools/parameters' do
  def app
    Modusynth::Controllers::ToolsResources::Parameters
  end
  
  let!(:account) { create(:account, admin: true) }
  let!(:session) { create(:session, account:) }
  let!(:category) { create(:dopefun) }
  let!(:tool) { create(:VCA, category:, experimental: false) }
  let!(:descriptor) { create(:frequency_descriptor) }
  let!(:synthesizer) { create(:synthesizer, account:) }
  let!(:mod) { create(:module, tool:, synthesizer:) }

  describe 'Nominal case' do
    before do
      post '/', {
        tool_id: tool.id.to_s,
        auth_token: session.token,
        name: 'custom parameter',
        targets: ['node1', 'node2'],
        descriptorId: descriptor.id.to_s,
        tool_id: tool.id.to_s
      }
    end
    it 'Returns a 201 (Created) status code' do
      expect(last_response.status).to be 201
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        name: 'custom parameter',
        targets: ['node1', 'node2']
      )
    end
    it 'Has correctly created a parameter on the tool' do
      expect(tool.parameters.where(name: 'custom parameter').count).to be 1
    end
    describe 'The created parameter' do
      let!(:parameter) { tool.reload && tool.parameters.last }

      it 'Has the correct name' do
        expect(parameter.name).to eq 'custom parameter'
      end
      it 'Has the correct targets' do
        expect(parameter.targets).to eq ['node1', 'node2']
      end
    end
    describe 'The created instanciation of the parameter in the modules' do
      before do
        [mod, tool].each(&:reload)
      end
      it 'Has created one parameter in the module' do
        descriptor = tool.parameters.where(name: 'custom parameter').first
        expect(mod.parameters.where(parameter: descriptor).count).to be 1
      end
      it 'Has created the parameter with the correct value' do
        expect(mod.parameters.last.value).to be tool.parameters.last.descriptor.default
      end
    end
  end
  describe 'Error cases' do
    describe 'When the name is not given' do
      before do
        post '/', {
          tool_id: tool.id.to_s,
          auth_token: session.token,
          targets: ['node1', 'node2'],
          descriptorId: descriptor.id.to_s
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'name', message: 'required'
        )
      end
      it 'Has not created a parameter' do
        expect(tool.parameters.count).to be 1
      end
    end
    describe 'When the descriptor UUID is not given' do
      before do
        post '/', {
          tool_id: tool.id.to_s,
          auth_token: session.token,
          targets: ['node1', 'node2']
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'descriptorId', message: 'required'
        )
      end
      it 'Has not created a parameter' do
        expect(tool.parameters.count).to be 1
      end
    end
    describe 'When the descriptor UUID is not found' do
      before do
        post '/', {
          tool_id: tool.id.to_s,
          auth_token: session.token,
          targets: ['node1', 'node2'],
          descriptorId: 'unknown'
        }
      end
      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'descriptorId', message: 'unknown'
        )
      end
      it 'Has not created a parameter' do
        expect(tool.parameters.count).to be 1
      end
    end
  end
end
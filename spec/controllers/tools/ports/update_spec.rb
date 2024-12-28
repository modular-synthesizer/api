RSpec.describe 'PUT /tools/ports/:id' do

  def app
    Modusynth::Controllers::ToolsResources::Ports
  end

  let!(:account) { create(:random_admin) }
  let!(:session) { create(:session, account:) }
  let!(:category) { create(:dopefun) }
  let!(:tool) { create(:VCA, category:, experimental: false) }
  let!(:synthesizer) { Modusynth::Services::Synthesizers.instance.create(account:, name: 'test synth') }
  let!(:mod) { create(:module, tool:, synthesizer:) }
  let!(:link) { create(:link, from: mod.ports.first, to: mod.ports.last, synthesizer:) }
  let!(:port) { tool.ports.first }

  describe 'Nominal cases' do

    describe 'Update the name of the port' do
      before do
        put "/#{port.id.to_s}", { auth_token: session.token, name: 'newname' }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          name: 'newname',
          index: 0,
          kind: 'input',
          target: 'gain'
        )
      end
      it 'Has updated the name correctly' do
        expect(Modusynth::Models::Tools::Port.find(port.id).name).to eq 'newname'
      end
      it 'Has not deleted the links as the structure has not changed' do
        expect(Modusynth::Models::Link.count).to be 1
      end
    end
    describe 'Update the target of the port' do
      before do
        put "/#{port.id.to_s}", { auth_token: session.token, target: 'newtarget' }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          name: 'INPUT',
          index: 0,
          kind: 'input',
          target: 'newtarget'
        )
      end
      it 'Has updated the target correctly' do
        expect(Modusynth::Models::Tools::Port.find(port.id).target).to eq 'newtarget'
      end
      it 'Has deleted all the links to the associated modules as the structure has changed' do
        expect(Modusynth::Models::Link.count).to be 0
      end
    end
    describe 'Update the kind of the port' do
      before do
        put "/#{port.id.to_s}", { auth_token: session.token, kind: 'output' }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          name: 'INPUT',
          index: 0,
          kind: 'output',
          target: 'gain'
        )
      end
      it 'Has updated the kind correctly' do
        expect(Modusynth::Models::Tools::Port.find(port.id).kind).to eq 'output'
      end
      it 'Has deleted all the links to the associated modules as the structure has changed' do
        expect(Modusynth::Models::Link.count).to be 0
      end
    end
    describe 'Update the index of the port' do
      before do
        put "/#{port.id.to_s}", { auth_token: session.token, index: 1 }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          name: 'INPUT',
          index: 1,
          kind: 'input',
          target: 'gain'
        )
      end
      it 'Has updated the index correctly' do
        expect(Modusynth::Models::Tools::Port.find(port.id).index).to be 1
      end
      it 'Has deleted all the links to the associated modules as the structure has changed' do
        expect(Modusynth::Models::Link.count).to be 0
      end
    end
  end

  describe 'Error cases' do
    describe 'When the name is too short' do
      before do
        put "/#{port.id.to_s}", { auth_token: session.token, name: 'a' }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'name', message: 'length'
        )
      end
      it 'Has not updated the name' do
        expect(Modusynth::Models::Tools::Port.find(port.id).name).to eq 'INPUT'
      end
    end
    describe 'When the kind is not in the possible values' do
      before do
        put "/#{port.id.to_s}", { auth_token: session.token, kind: 'test' }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'kind', message: 'value'
        )
      end
      it 'Has not updated the kind' do
        expect(Modusynth::Models::Tools::Port.find(port.id).kind).to eq 'input'
      end
      it 'Has not deleted any link' do
        expect(Modusynth::Models::Link.count).to be 1
      end
    end
    describe 'When the index is below zero' do
      before do
        put "/#{port.id.to_s}", { auth_token: session.token, index: -1 }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'index', message: 'value'
        )
      end
      it 'Has not updated the kind' do
        expect(Modusynth::Models::Tools::Port.find(port.id).index).to be 0
      end
      it 'Has not deleted any link' do
        expect(Modusynth::Models::Link.count).to be 1
      end
    end
  end
end
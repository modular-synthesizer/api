RSpec.describe 'POST /tools/:tool_id/ports' do

  def app
    Modusynth::Controllers::ToolsResources::Ports
  end

  let!(:account) { create(:account, admin: true) }
  let!(:session) { create(:session, account:) }
  let!(:category) { create(:dopefun) }
  let!(:tool) { create(:VCA, category:, experimental: false) }
  let!(:synthesizer) { create(:synthesizer, account:) }
  let!(:mod) { create(:module, tool:, synthesizer:) }

  describe 'Nominal case' do
    before do
      post '/', {
        tool_id: tool.id.to_s,
        auth_token: session.token,
        name: 'custom port',
        kind: 'input',
        index: 0,
        target: 'test target'
      }
    end
    it 'Returns a 201 (Created) status code' do
      expect(last_response.status).to be 201
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        name: 'custom port',
        kind: 'input',
        index: 0,
        target: 'test target'
      )
    end
    describe 'Created port' do
      let!(:port) { Modusynth::Models::Tools::Port.last }

      it 'Has the correct kind' do
        expect(port.kind).to eq 'input'
      end
      it 'Has the correct name' do
        expect(port.name).to eq 'custom port'
      end
      it 'Has the correct target' do
        expect(port.target).to eq 'test target'
      end
      it 'Has the correct index' do
        expect(port.index).to be 0
      end
      it 'Has the correct tool' do
        expect(port.tool.id).to eq tool.id
      end
      it 'Has added the port in the corresponding modules' do
        expect(mod.ports.where(descriptor_id: port.id).count).to be 1
      end
    end

    describe 'Error cases' do
      describe 'When the name is not given' do
        before do
          post '/', {
            tool_id: tool.id.to_s,
            auth_token: session.token,
            kind: 'input',
            index: 0,
            target: 'test target'
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
      end
      describe 'When the name is too short' do
        before do
          post '/', {
            tool_id: tool.id.to_s,
            auth_token: session.token,
            name: 'IN',
            kind: 'input',
            index: 0,
            target: 'test target'
          }
        end
        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'name', message: 'length'
          )
        end
      end
      describe 'When the index is not given' do
        before do
          post '/', {
            tool_id: tool.id.to_s,
            auth_token: session.token,
            name: 'custom port',
            kind: 'input',
            target: 'test target'
          }
        end
        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'index', message: 'required'
          )
        end
      end
      describe 'When the index is below zero' do
        before do
          post '/', {
            tool_id: tool.id.to_s,
            auth_token: session.token,
            name: 'custom port',
            kind: 'input',
            index: -1,
            target: 'test target'
          }
        end
        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'index', message: 'value'
          )
        end
      end
      describe 'When the tool UUID is not given' do
        before do
          post '/', {
            auth_token: session.token,
            name: 'custom port',
            kind: 'input',
            index: -0,
            target: 'test target'
          }
        end
        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'tool_id', message: 'required'
          )
        end
      end
      describe 'When the tool UUID is not found' do
        before do
          post '/', {
            auth_token: session.token,
            tool_id: 'unknown',
            name: 'custom port',
            kind: 'input',
            index: -0,
            target: 'test target'
          }
        end
        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 404
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'tool_id', message: 'unknown'
          )
        end
      end
    end
  end
end
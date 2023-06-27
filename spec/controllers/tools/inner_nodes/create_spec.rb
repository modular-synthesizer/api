RSpec.describe 'POST /tools/nodes' do
  def app
    Modusynth::Controllers::ToolsResources::InnerNodes
  end
  
  let!(:account) { create(:account, admin: true) }
  let!(:session) { create(:session, account:) }
  let!(:category) { create(:dopefun) }
  let!(:tool) { create(:VCA, category:, experimental: false) }
  
  describe 'Nominal case' do
    before do
      post '/', {
        auth_token: session.token,
        x: 100,
        y: 200,
        name: 'inner-node',
        generator: 'NodeGenerator',
        tool_id: tool.id.to_s
      }
    end
    it 'Returns a 201 (Created) status code' do
      expect(last_response.status).to be 201
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        x: 100,
        y: 200,
        name: 'inner-node',
        generator: 'NodeGenerator'
      )
    end
    describe 'The created inner node' do
      let!(:node) { tool.reload; tool.inner_nodes.last }

      it 'Has the correct name' do
        expect(node.name).to eq 'inner-node'
      end
      it 'Has the correct generator' do
        expect(node.generator).to eq 'NodeGenerator'
      end
    end
  end
  describe 'Alternative cases' do
    describe 'When the X coordinate is not given' do
      before do
        post '/', {
          auth_token: session.token,
          y: 200,
          name: 'inner-node',
          generator: 'NodeGenerator',
          tool_id: tool.id.to_s
        }
      end
      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          x: 0,
          y: 200,
          name: 'inner-node',
          generator: 'NodeGenerator'
        )
      end
      it 'Has filled the remaining coordinate with the correct default value' do
        tool.reload
        expect(tool.inner_nodes.last.x).to be 0
      end
    end
    describe 'When the Y coordinate is not given' do
      before do
        post '/', {
          auth_token: session.token,
          x: 100,
          name: 'inner-node',
          generator: 'NodeGenerator',
          tool_id: tool.id.to_s
        }
      end
      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          x: 100,
          y: 0,
          name: 'inner-node',
          generator: 'NodeGenerator'
        )
      end
      it 'Has filled the remaining coordinate with the correct default value' do
        tool.reload
        expect(tool.inner_nodes.last.y).to be 0
      end
    end
  end
  describe 'Error cases' do
    describe 'When the name is not given' do
      before do
        post '/', {
          auth_token: session.token,
          tool_id: tool.id.to_s,
          generator: 'NodeGenerator'
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
      it 'Has created no new inner node' do
        tool.reload
        expect(tool.inner_nodes.where(generator: 'NodeGenerator').count).to be 0
      end
    end
    describe 'When the name is too short' do
      before do
        post '/', {
          auth_token: session.token,
          tool_id: tool.id.to_s,
          name: 'a',
          generator: 'NodeGenerator'
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
      it 'Has created no new inner node' do
        tool.reload
        expect(tool.inner_nodes.where(generator: 'NodeGenerator').count).to be 0
      end
    end
    describe 'When the generator is not given' do
      before do
        post '/', {
          auth_token: session.token,
          tool_id: tool.id.to_s,
          name: 'inner-node'
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'generator', message: 'required'
        )
      end
      it 'Has created no new inner node' do
        tool.reload
        expect(tool.inner_nodes.where(generator: 'NodeGenerator').count).to be 0
      end
    end
    describe 'When the generator is too short' do
      before do
        post '/', {
          auth_token: session.token,
          tool_id: tool.id.to_s,
          name: 'inner-node',
          generator: 'A'
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'generator', message: 'length'
        )
      end
      it 'Has created no new inner node' do
        tool.reload
        expect(tool.inner_nodes.where(generator: 'NodeGenerator').count).to be 0
      end
    end
    describe 'When the tool UUID is not given' do
      before do
        post '/', {
          auth_token: session.token,
          name: 'inner-node',
          generator: 'NodeGenerator'
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
      it 'Has created no new inner node' do
        tool.reload
        expect(tool.inner_nodes.where(generator: 'NodeGenerator').count).to be 0
      end
    end
    describe 'When the tool is not found' do
      before do
        post '/', {
          auth_token: session.token,
          tool_id: 'unknown',
          name: 'inner-node',
          generator: 'NodeGenerator'
        }
      end
      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'tool_id', message: 'unknown'
        )
      end
      it 'Has created no new inner node' do
        tool.reload
        expect(tool.inner_nodes.where(generator: 'NodeGenerator').count).to be 0
      end
    end
  end
end
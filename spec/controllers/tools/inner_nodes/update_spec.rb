RSpec.describe 'PUT /tools/nodes/:id' do
  def app
    Modusynth::Controllers::ToolsResources::InnerNodes
  end
  
  let!(:account) { create(:account, admin: true) }
  let!(:session) { create(:session, account:) }
  let!(:category) { create(:dopefun) }
  let!(:tool) { create(:VCA, category:, experimental: false) }
  let!(:node) { tool.inner_nodes.first }

  describe 'Nominal case' do
    before do
      put "/#{node.id.to_s}", {
        auth_token: session.token,
        tool_id: tool.id.to_s
      }
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        id: node.id.to_s,
        name: node.name,
        generator: node.generator,
        x: node.x,
        y: node.y
      )
    end
  end
  describe 'Alternative cases' do
    describe 'Update the name' do
      before do
        put "/#{node.id.to_s}", {
          auth_token: session.token,
          name: 'new-name',
          tool_id: tool.id.to_s
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: node.id.to_s,
          name: 'new-name',
          generator: node.generator,
          x: node.x,
          y: node.y
        )
      end
      it 'Has correctly updated the name' do
        node.reload
        expect(node.name).to eq 'new-name'
      end
    end
    describe 'Update the generator' do
      before do
        put "/#{node.id.to_s}", {
          auth_token: session.token,
          generator: 'NewGenerator',
          tool_id: tool.id.to_s
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: node.id.to_s,
          name: node.name,
          generator: 'NewGenerator',
          x: node.x,
          y: node.y
        )
      end
      it 'Has correctly updated the generator' do
        node.reload
        expect(node.generator).to eq 'NewGenerator'
      end
    end
    describe 'Update the X coordinate' do
      before do
        put "/#{node.id.to_s}", {
          auth_token: session.token,
          tool_id: tool.id.to_s,
          x: 0
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: node.id.to_s,
          name: node.name,
          generator: node.generator,
          x: 0,
          y: node.y
        )
      end
      it 'Has correctly updated the X coordinate' do
        node.reload
        expect(node.x).to be 0
      end
    end
    describe 'Update the Y coordinate' do
      before do
        put "/#{node.id.to_s}", {
          auth_token: session.token,
          tool_id: tool.id.to_s,
          y: 0
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: node.id.to_s,
          name: node.name,
          generator: node.generator,
          x: node.x,
          y: 0
        )
      end
      it 'Has correctly updated the Y coordinate' do
        node.reload
        expect(node.y).to be 0
      end
    end
  end
  describe 'Error cases' do
    describe 'When the name is nil' do
      before do
        put "/#{node.id.to_s}", {
          auth_token: session.token,
          tool_id: tool.id.to_s,
          name: nil
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
        put "/#{node.id.to_s}", {
          auth_token: session.token,
          tool_id: tool.id.to_s,
          name: 'a'
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
    describe 'When the generator is nil' do
      before do
        put "/#{node.id.to_s}", {
          auth_token: session.token,
          tool_id: tool.id.to_s,
          generator: nil
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
    end
    describe 'When the generator is too short' do
      before do
        put "/#{node.id.to_s}", {
          auth_token: session.token,
          tool_id: tool.id.to_s,
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
    end
    describe 'When the tool UUID is not given' do
      before do
        put "/#{node.id.to_s}", {
          auth_token: session.token,
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
    describe 'When the tool is not found' do
      before do
        put "/#{node.id.to_s}", {
          auth_token: session.token,
          tool_id: 'unknown'
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
    end
    describe 'When the UUID is not found' do
      before do
        put '/unknown', {
          auth_token: session.token,
          tool_id: tool.id.to_s
        }
      end
      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'id', message: 'unknown'
        )
      end
    end
  end
end
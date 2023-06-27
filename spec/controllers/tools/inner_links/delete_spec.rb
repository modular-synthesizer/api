RSpec.describe 'DELETE /tools/links/:id' do
  def app
    Modusynth::Controllers::ToolsResources::InnerLinks
  end
  
  let!(:account) { create(:account, admin: true) }
  let!(:session) { create(:session, account:) }
  let!(:category) { create(:dopefun) }
  let!(:tool) { create(:VCA, category:, experimental: false) }
  let!(:link) do
    Modusynth::Services::ToolsResources::InnerLinks.instance.create(
      auth_token: session.token,
      tool: tool,
      from: { node: 'from-node', index: 1 },
      to: { node: 'to-node', index: 2 }
    )
  end

  describe 'Nominal case' do
    before do
      delete "/#{link.id.to_s}", {
        auth_token: session.token,
        tool_id: tool.id.to_s
      }
    end
    it 'Returns a 204 (Not Content) status code' do
      expect(last_response.status).to be 204
    end
    it 'Has deleted the link' do
      tool.reload
      expect(tool.inner_links.where(id: link.id).count).to be 0
    end
  end
  describe 'Alternative cases' do
    before do
      delete '/unknown', {
        auth_token: session.token,
        tool_id: tool.id.to_s
      }
    end
    describe 'When the node is not found' do
      it 'Returns a 204 (Not Content) status code' do
        expect(last_response.status).to be 204
      end
      it 'Has not deleted the node' do
        expect(tool.inner_links.count).to be 1
      end
    end
  end
  describe 'Error cases' do
    describe 'Where the tool UUID is not given' do
      before do
        delete "/#{link.id.to_s}", { auth_token: session.token }
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
        delete "/#{link.id.to_s}", {
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
  end
end
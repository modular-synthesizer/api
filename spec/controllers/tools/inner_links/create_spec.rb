RSpec.describe 'POST /tools/links' do
  def app
    Modusynth::Controllers::ToolsResources::InnerLinks
  end
  
  let!(:account) { create(:random_admin) }
  let!(:session) { create(:session, account:) }
  let!(:category) { create(:dopefun) }
  let!(:tool) { create(:VCA, category:, experimental: false) }

  before do
    tool.reload
  end

  describe 'Nominal case' do
    before do
      post '/', {
        auth_token: session.token,
        tool_id: tool.id.to_s,
        from: { node: 'from-node', index: 1 },
        to: { node: 'to-node', index: 2 }
      }
    end
    it 'Returns a 201 (Created) status code' do
      expect(last_response.status).to be 201
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        from: { node: 'from-node', index: 1 },
        to: { node: 'to-node', index: 2 }
      )
    end
    describe 'The created link' do
      let!(:link) { tool.reload; tool.inner_links.last }

      it 'Has a correct origin node' do
        expect(link.from.node).to eq 'from-node'
      end
      it 'Has a correct origin index' do
        expect(link.from.index).to be 1
      end
      it 'Has a correct destination node' do
        expect(link.to.node).to eq 'to-node'
      end
      it 'Has a correct destination index' do
        expect(link.to.index).to be 2
      end
    end
  end
  describe 'Alternative case' do
    describe 'The origin index is not given' do
      before do
        post '/', {
          auth_token: session.token,
          tool_id: tool.id.to_s,
          from: { node: 'from-node' },
          to: { node: 'to-node', index: 2 }
        }
      end
      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          from: { node: 'from-node', index: 0 },
          to: { node: 'to-node', index: 2 }
        )
      end
      it 'Has filled the index with the default value' do
        tool.reload
        expect(tool.inner_links.last.from.index).to be 0
      end
    end
    describe 'The destination index is not given' do
      before do
        post '/', {
          auth_token: session.token,
          tool_id: tool.id.to_s,
          from: { node: 'from-node', index: 1 },
          to: { node: 'to-node' }
        }
      end
      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          from: { node: 'from-node', index: 1 },
          to: { node: 'to-node', index: 0 }
        )
      end
      it 'Has filled the index with the default value' do
        tool.reload
        expect(tool.inner_links.last.to.index).to be 0
      end
    end
  end
  describe 'Error cases' do
    describe 'The origin payload is not given' do
      before do
        post '/', {
          auth_token: session.token,
          tool_id: tool.id.to_s,
          to: { node: 'to-node' }
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'from', message: 'required'
        )
      end
      it 'Has created no new link' do
        expect(tool.inner_links.count).to be 0
      end
    end
    describe 'The origin node is not given' do
      before do
        post '/', {
          auth_token: session.token,
          tool_id: tool.id.to_s,
          from: { index: 1 },
          to: { node: 'to-node', index: 2 }
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'from.node', message: 'required'
        )
      end
      it 'Has created no new link' do
        expect(tool.inner_links.count).to be 0
      end
    end
    describe 'The origin index is below zero' do
      before do
        post '/', {
          auth_token: session.token,
          tool_id: tool.id.to_s,
          from: { node: 'from-node', index: -1 },
          to: { node: 'to-node', index: 2 }
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'from.index', message: 'value'
        )
      end
      it 'Has created no new link' do
        expect(tool.inner_links.count).to be 0
      end
    end
    describe 'The destination payload is not given' do
      before do
        post '/', {
          auth_token: session.token,
          tool_id: tool.id.to_s,
          from: { node: 'from-node', index: 1 }
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'to', message: 'required'
        )
      end
      it 'Has created no new link' do
        expect(tool.inner_links.count).to be 0
      end
    end
    describe 'The destination node is not given' do
      before do
        post '/', {
          auth_token: session.token,
          tool_id: tool.id.to_s,
          from: { node: 'from-node', index: 1 },
          to: { index: 2 }
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'to.node', message: 'required'
        )
      end
      it 'Has created no new link' do
        expect(tool.inner_links.count).to be 0
      end
    end
    describe 'The destination index is below zero' do
      before do
        post '/', {
          auth_token: session.token,
          tool_id: tool.id.to_s,
          from: { node: 'from-node', index: 1 },
          to: { node: 'to-node', index: -1 }
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'to.index', message: 'value'
        )
      end
      it 'Has created no new link' do
        expect(tool.inner_links.count).to be 0
      end
    end
    describe 'The tool UUID is not given' do
      before do
        post '/', {
          auth_token: session.token,
          from: { node: 'from-node', index: 1 },
          to: { node: 'to-node', index: 2 }
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
      it 'Has created no new link' do
        expect(tool.inner_links.count).to be 0
      end
    end
    describe 'The tool is not found' do
      before do
        post '/', {
          auth_token: session.token,
          tool_id: 'unknown',
          from: { node: 'from-node', index: 1 },
          to: { node: 'to-node', index: 2 }
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
      it 'Has created no new link' do
        expect(tool.inner_links.count).to be 0
      end
    end
  end
end
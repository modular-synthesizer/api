RSpec.describe 'PUT /:id' do
  def app
    Modusynth::Controllers::Tools
  end

  let!(:account) { create(:babausse, admin: true) }
  let!(:session) { create(:session, account:) }
  let!(:dopefun) { create(:dopefun) }
  let!(:tool) { create(:VCA, category: dopefun) }

  describe 'Nominal case' do
    describe 'When nothing is updated' do
      before do
        put "/#{tool.id.to_s}", {auth_token: session.token}
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: tool.id.to_s,
          name: tool.name,
          slots: tool.slots
        )
      end
    end
  end

  describe 'Alternative cases' do
    describe 'Update the name' do
      before do
        put "/#{tool.id.to_s}", {auth_token: session.token, name: 'OtherName'}
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: tool.id.to_s,
          name: 'OtherName',
        )
      end
    end
    describe 'Update the slots' do
      before do
        put "/#{tool.id.to_s}", {auth_token: session.token, slots: 42}
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: tool.id.to_s,
          slots: 42,
        )
      end
    end
    describe 'Update the category' do
      let!(:category) { create(:category, name: 'common') }

      before do
        put "/#{tool.id.to_s}", {
          auth_token: session.token,
          categoryId: category.id.to_s
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          category: {id: category.id.to_s}
        )
      end
      describe 'The update category' do
        before { tool.reload }

        it 'Has the correct category' do
          expect(tool.category.id).to eq category.id
        end
      end
    end
    describe 'Update the inner nodes' do
      before do
        node = tool.inner_nodes.first
        put "/#{tool.id.to_s}", {
          auth_token: session.token,
          nodes: [
            {id: node.id.to_s, name: node.name, generator: node.generator},
            {name: 'biquad', generator: 'BiquadFilterNode'}
          ]
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          nodes: [
            {name: 'gain', generator: 'GainNode'},
            {name: 'biquad', generator: 'BiquadFilterNode'}
          ]
        )
      end
      describe 'The nodes in the tool' do
        before do
          tool.reload
        end
        it 'Has the correct first node' do
          expect(tool.inner_nodes.first.name).to eq 'gain'
        end
        it 'Has the correct second node' do
          expect(tool.inner_nodes.last.name).to eq 'biquad'
        end
        it 'Has deleted the rest of the nodes' do
          expect(tool.inner_nodes.count).to be 2
        end
      end
    end
    describe 'Update the inner links' do
      before do
        node = tool.inner_nodes.first
        put "/#{tool.id.to_s}", {
          auth_token: session.token,
          links: [
            {from: {node: 'gain', index: 0}, to: {node: 'gain', index: 0}}
          ]
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          links: [
            {from: {node: 'gain', index: 0}, to: {node: 'gain', index: 0}}
          ]
        )
      end
      describe 'The links in the tool' do
        before do
          tool.reload
        end
        it 'Has the correct link' do
          expect(tool.inner_links.first.from.node).to eq 'gain'
        end
        it 'Has created only one link' do
          expect(tool.inner_links.count).to be 1
        end
      end
    end
  end

  describe 'Error cases' do
    describe 'Tool not found' do
      before do
        put '/unknown', {auth_token: session.token}
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
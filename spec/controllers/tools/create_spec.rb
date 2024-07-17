RSpec.shared_examples 'empty lists' do
  it 'has Created no tool' do
    expect(Modusynth::Models::Tool.all.size).to be 0
  end
  it 'Has created no ports' do
    expect(Modusynth::Models::Tools::Port.all.size).to be 0
  end
end


RSpec.describe Modusynth::Controllers::Tools do
  def app
    Modusynth::Controllers::Tools
  end

  describe 'POST /' do

    let!(:admin) { create(:random_admin) }
    let!(:session) { create(:session, account: admin) }
    let!(:dopefun) { create(:dopefun) }

    describe 'Nominal case' do
      before do
        post '/', {name: 'VCA', slots: 3, auth_token: session.token, categoryId: dopefun.id.to_s}.to_json
      end

      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          name: 'VCA',
          slots: 3,
          nodes: [],
          links: [],
          ports: []
        )
      end
      describe 'Created tool' do
        let!(:tool) { Modusynth::Models::Tool.first }

        it 'Has the correct name' do
          expect(tool.name).to eq 'VCA'
        end
        it 'has the correct number of slots' do
          expect(tool.slots).to be 3
        end
        it 'has no inner nodes' do
          expect(tool.inner_nodes).to eq []
        end
        it 'Has no linked parameters' do
          expect(tool.parameters).to eq []
        end
      end
    end

    describe 'Alternative cases' do
      describe 'Tool with inner nodes' do
        before do
          post '/', {
            name: 'VCA',
            slots: 3,
            auth_token: session.token,
            categoryId: dopefun.id.to_s,
            nodes: [{ name: 'gain', generator: 'GainNode'}]
          }.to_json
        end

        it 'Returns a 201 (Created) status code' do
          expect(last_response.status).to be 201
        end
        it 'Returns the correct body' do
          creation = Modusynth::Models::Tool.first
          expect(last_response.body).to include_json(
            id: creation.id.to_s,
            name: 'VCA',
            slots: 3,
            nodes: [{
              id: creation.inner_nodes.first.id.to_s,
              name: 'gain',
              generator: 'GainNode'
            }]
          )
        end

        describe 'Created inner nodes' do
          let!(:tool) { Modusynth::Models::Tool.first }
          let!(:node) { tool.inner_nodes.first }

          it 'Has created exactly one inner node' do
            expect(tool.inner_nodes.size).to be 1
          end
          it 'Has created a node with the correct name' do
            expect(node.name).to eq 'gain'
          end
          it 'Has created a node wih the correct generator' do
            expect(node.generator).to eq 'GainNode'
          end
        end
      end
      describe 'Tools with placed inner nodes' do
        before do
          post '/', {
            name: 'VCA',
            slots: 3,
            auth_token: session.token,
            categoryId: dopefun.id.to_s,
            nodes: [{ name: 'gain', generator: 'GainNode', x: 100, y: 200}]
          }.to_json
        end
        it 'Returns a 201 (Created) status code' do
          expect(last_response.status).to be 201
        end
        it 'Returns the correct body' do
          creation = Modusynth::Models::Tool.first
          expect(last_response.body).to include_json(
            id: creation.id.to_s,
            name: 'VCA',
            slots: 3,
            nodes: [{
              id: creation.inner_nodes.first.id.to_s,
              name: 'gain',
              generator: 'GainNode',
              x: 100,
              y: 200
            }]
          )
        end
        describe 'The created node coordinates' do
          let!(:creation) { Modusynth::Models::Tool.first.inner_nodes.first }

          it 'Has the correct X coordinate' do
            expect(creation.x).to be 100
          end
          it 'Has the correct Y coordinate' do
            expect(creation.y).to be 200
          end
        end
      end
      describe 'Tool with inner links' do
        before do
          post '/', {
            name: 'VCA',
            slots: 3,
            auth_token: session.token,
            categoryId: dopefun.id.to_s,
            links: [{from: {node: 'oscillator', index: 0}, to: {node: 'gain', index: 1}}]
          }.to_json
        end

        describe 'Created inner link' do
          let!(:tool) { Modusynth::Models::Tool.first }
          let!(:link) { tool.inner_links.first }
          let!(:from) { link.from }
          let!(:to) { link.to }
  
          it 'Has created exactly one inner link' do
            expect(tool.inner_links.size).to be 1
          end
          it 'Has creatd a link with the correct origin node' do
            expect(from.node).to eq 'oscillator'
          end
          it 'Has creatd a link with the correct origin index' do
            expect(from.index).to be 0
          end
          it 'Has creatd a link with the correct destination node' do
            expect(to.node).to eq 'gain'
          end
          it 'Has creatd a link with the correct destination index' do
            expect(to.index).to be 1
          end
        end
        
        describe 'The origin index is not given' do
          before do
            post '/', {
              slots: 3,
              categoryId: dopefun.id.to_s,
              name: 'testtool',
              auth_token: session.token,
              links: [{to: {node: 'test', index: 0}, from: {node: 'other'}}]
            }.to_json
          end

          it 'Returns a 201 (Created) status code' do
            expect(last_response.status).to be 201
          end
          it 'Returns the correct body' do
            expect(last_response.body).to include_json(
              links: [
                { from: { index: 0 } }
              ]
            )
          end
        end
        
        describe 'The destination index is not given' do
          before do
            post '/', {
              slots: 3,
              categoryId: dopefun.id.to_s,
              name: 'testtool',
              auth_token: session.token,
              links: [{to: {node: 'test'}, from: {node: 'other', index: 0}}]
            }.to_json
          end

          it 'Returns a 201 (Created) status code' do
            expect(last_response.status).to be 201
          end
          it 'Returns the correct body' do
            expect(last_response.body).to include_json(
              links: [
                { to: { index: 0 } }
              ]
            )
          end
        end
      end
      describe 'Tool with parameters' do
        before do
          post '/', {
            name: 'VCA',
            slots: 3,
            auth_token: session.token,
            categoryId: dopefun.id.to_s,
            parameters: [{targets: ['target'], name: 'testparam', field: 'testfield'}]
          }.to_json
        end

        it 'Returns a 201 (Created) status code' do
          expect(last_response.status).to be 201
        end
        it 'Returns the correct body' do
          creation = Modusynth::Models::Tool.first
          expect(last_response.body).to include_json(
            id: creation.id.to_s,
            name: 'VCA',
            slots: 3,
            parameters: [{
              name: 'testparam',
              targets: ['target'],
              field: 'testfield',
              default: 50,
              minimum: 0,
              maximum: 100,
              step: 1,
              precision: 0
            }]
          )
        end
      end
      describe 'Tool with inputs' do
        before do
          post '/', {
            name: 'VCA',
            slots: 3,
            auth_token: session.token,
            categoryId: dopefun.id.to_s,
            ports: [{kind: 'input', name: 'INPUT', target: 'gain', index: 0}]
          }.to_json
        end

        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            id: Modusynth::Models::Tool.first.id.to_s,
            name: 'VCA',
            slots: 3,
            ports: [{name: 'INPUT', index: 0, target: 'gain'}]
          )
        end
        describe 'Created input port' do
          let!(:tool) { Modusynth::Models::Tool.first }
          let!(:input) { tool.inputs.first }

          it 'Has created only one input' do
            expect(tool.inputs.size).to be 1
          end
          it 'Has created a port with the correct name' do
            expect(input.name).to eq 'INPUT'
          end
          it 'Has created a port with the correct targets' do
            expect(input.target).to eq 'gain'
          end
          it 'Has created a port with the correct index' do
            expect(input.index).to be 0
          end
        end
      end
      describe 'Tool with outputs' do
        before do
          post '/', {
            name: 'VCA',
            slots: 3,
            auth_token: session.token,
            categoryId: dopefun.id.to_s,
            ports: [{kind: 'output', name: 'OUTPUT', target: 'gain', index: 0}]
          }.to_json
        end

        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            id: Modusynth::Models::Tool.first.id.to_s,
            name: 'VCA',
            slots: 3,
            ports: [{name: 'OUTPUT', index: 0, target: 'gain'}]
          )
        end
        describe 'Created input port' do
          let!(:tool) { Modusynth::Models::Tool.first }
          let!(:output) { tool.outputs.first }

          it 'Has created only one input' do
            expect(tool.outputs.size).to be 1
          end
          it 'Has created a port with the correct name' do
            expect(output.name).to eq 'OUTPUT'
          end
          it 'Has created a port with the correct targets' do
            expect(output.target).to eq 'gain'
          end
          it 'Has created a port with the correct index' do
            expect(output.index).to be 0
          end
        end
      end
    end

    describe 'Error cases' do
      describe 'No name given' do
        before do
          post '/', {slots: 3, categoryId: dopefun.id.to_s, auth_token: session.token}.to_json
        end

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'name', message: 'required'})
        end
        include_examples 'empty lists'
      end
      describe 'Name too short' do
        before do
          post '/', {slots: 3, categoryId: dopefun.id.to_s, auth_token: session.token, name: 'a'}.to_json
        end

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'name', message: 'minlength'})
        end
        include_examples 'empty lists'
      end
      describe 'Slots not given' do
        before do
          post '/', {name: 'foobar', categoryId: dopefun.id.to_s, auth_token: session.token}.to_json
        end

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'slots', message: 'required'})
        end
        include_examples 'empty lists'
      end
      describe 'Slots given with negative value' do
        before do
          post '/', {
            slots: -1,
            name: 'foobar',
            categoryId: dopefun.id.to_s,
            auth_token: session.token
          }.to_json
        end

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'slots', message: 'value'})
        end
        include_examples 'empty lists'
      end
      describe 'Slots given with zero as value' do
        before do
          post '/', {slots: 0, name: 'foobar', categoryId: dopefun.id.to_s, auth_token: session.token}.to_json
        end

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'slots', message: 'value'})
        end
        include_examples 'empty lists'
      end
    end

    describe 'Inner nodes error cases' do
      describe 'name not given' do
        before do
          post '/', {
            slots: 3,
            categoryId: dopefun.id.to_s,
            name: 'testtool',
            auth_token: session.token,
            nodes: [{generator: 'GainNode'}]
          }.to_json
        end

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'nodes[0].name', message: 'required'})
        end
        include_examples 'empty lists'
      end

      describe 'name too short' do
        before do
          post '/', {
            slots: 3,
            categoryId: dopefun.id.to_s,
            name: 'testtool',
            auth_token: session.token,
            nodes: [{name: 'a', generator: 'GainNode'}]
          }.to_json
        end

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'nodes[0].name', message: 'length'})
        end
        include_examples 'empty lists'
      end

      describe 'generator not given' do
        before do
          post '/', {
            slots: 3,
            categoryId: dopefun.id.to_s,
            name: 'testtool',
            auth_token: session.token,
            nodes: [{name: 'testnode'}]
          }.to_json
        end

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'nodes[0].generator', message: 'required'})
        end
        include_examples 'empty lists'
      end

      describe 'generator name too short' do
        before do
          post '/', {
            slots: 3,
            categoryId: dopefun.id.to_s,
            name: 'testtool',
            auth_token: session.token,
            nodes: [{generator: 'a', name: 'testnode'}]
          }.to_json
        end

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'nodes[0].generator', message: 'length'})
        end
        include_examples 'empty lists'
      end
    end

    describe 'Inner links error cases' do
      describe 'The origin is not given' do
        before do
          post '/', {
            slots: 3,
            categoryId: dopefun.id.to_s,
            name: 'testtool',
            auth_token: session.token,
            links: [{to: {node: 'test', index: 0}}]
          }.to_json
        end

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'links[0].from', message: 'required'
          )
        end
        include_examples 'empty lists'
      end
      describe 'The origin node is not given' do
        before do
          post '/', {
            slots: 3,
            categoryId: dopefun.id.to_s,
            name: 'testtool',
            auth_token: session.token,
            links: [{to: {node: 'test', index: 0}, from: {index: 0}}]
          }.to_json
        end

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'links[0].from.node', message: 'required'
          )
        end
        include_examples 'empty lists'
      end
      describe 'The destination is not given' do
        before do
          post '/', {
            slots: 3,
            categoryId: dopefun.id.to_s,
            name: 'testtool',
            auth_token: session.token,
            links: [{from: {node: 'test', index: 0}}]
          }.to_json
        end

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'links[0].to', message: 'required'
          )
        end
        include_examples 'empty lists'
      end
      describe 'The destination node is not given' do
        before do
          post '/', {
            slots: 3,
            categoryId: dopefun.id.to_s,
            name: 'testtool',
            auth_token: session.token,
            links: [{from: {node: 'test', index: 0}, to: {index: 0}}]
          }.to_json
        end

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'links[0].to.node', message: 'required'
          )
        end
        include_examples 'empty lists'
      end
    end

    include_examples 'authentication', 'post', '/'
    include_examples 'scopes', 'post', '/'
  end
end
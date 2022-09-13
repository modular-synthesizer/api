RSpec.describe Modusynth::Controllers::Tools do
  def app
    Modusynth::Controllers::Tools
  end

  describe 'GET /' do
    describe 'empty list' do
      before { get '/' }

      it 'returns an empty list when nothing has been created' do
        expect(last_response.body).to include_json({tools: []})
      end
    end
  end

  describe 'POST /' do

    def create(body = {})
      post '/', body.to_json, 'CONTENT_TYPE' => 'application/json'
    end

    describe 'Nominal case' do
      before { create({name: 'test', slots: 10}) }

      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: Modusynth::Models::Tool.first.id.to_s,
          name: 'test',
          slots: 10,
          innerNodes: [],
          innerLinks: []
        )
      end
      describe 'Created tool' do
        let!(:tool) { Modusynth::Models::Tool.first }

        it 'Has the correct name' do
          expect(tool.name).to eq 'test'
        end
        it 'has the correct number of slots' do
          expect(tool.slots).to be 10
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
        before { create({name: 'test', slots: 10, inner_nodes: [{ name: 'foo', factory: 'bar' }]}) }

        it 'Returns a 201 (Created) status code' do
          expect(last_response.status).to be 201
        end
        it 'Returns the correct body' do
          creation = Modusynth::Models::Tool.first
          expect(last_response.body).to include_json(
            id: creation.id.to_s,
            name: 'test',
            slots: 10,
            innerNodes: [{
              id: creation.inner_nodes.first.id.to_s,
              name: 'foo',
              factory: 'bar'
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
            expect(node.name).to eq 'foo'
          end
          it 'Has created a node wih the correct factory' do
            expect(node.factory).to eq 'bar'
          end
        end
      end
      describe 'Tool with inner links' do
        before do
          create({
            name: 'test',
            slots: 10,
            inner_nodes: [
              { name: 'foo', factory: 'bar' },
              { name: 'baz', factory: 'bar' }
            ],
            inner_links: [{from: {node: 'foo', index: 0}, to: {node: 'baz', index: 1}}]
          })
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
            expect(from.node).to eq 'foo'
          end
          it 'Has creatd a link with the correct origin index' do
            expect(from.index).to be 0
          end
          it 'Has creatd a link with the correct destination node' do
            expect(to.node).to eq 'baz'
          end
          it 'Has creatd a link with the correct destination index' do
            expect(to.index).to be 1
          end
        end
      end
      describe 'Tool with parameters' do
        let!(:param) do
          Modusynth::Services::Parameters.instance.create(
            'name' => 'parameter',
            'minimum' => 0,
            'maximum' => 10,
            'step' => 1,
            'precision' => 0,
            'default' => 1
          )
        end
        before do
          create({name: 'test', slots: 10, parameters: [param.id.to_s]})
        end

        it 'Returns a 201 (Created) status code' do
          expect(last_response.status).to be 201
        end
        it 'Returns the correct body' do
          creation = Modusynth::Models::Tool.first
          expect(last_response.body).to include_json(
            id: creation.id.to_s,
            name: 'test',
            slots: 10,
            parameters: [{
              name: 'parameter',
              targets: [],
              value: 1,
              constraints: {
                minimum: 0,
                maximum: 10,
                step: 1,
                precision: 0
              }
            }]
          )
        end
      end
    end

    describe 'Error cases' do
      describe 'No name given' do
        before { create }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'name', message: 'required'})
        end
      end

      describe 'Name too short' do
        before { create({name: 'a'}) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'name', message: 'length'})
        end
      end

      describe 'Slots not given' do
        before { create({name: 'test'}) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'slots', message: 'required'})
        end
      end

      describe 'Slots given with negative value' do
        before { create({name: 'test', slots: -1}) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'slots', message: 'value'})
        end
      end

      describe 'Slots given with zero as value' do
        before { create({name: 'test', slots: 0}) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'slots', message: 'value'})
        end
      end
    end

    describe 'Inner nodes error cases' do

      def create_with_node(payload = {})
        create({name: 'test', slots: 10, inner_nodes: [payload]})
      end

      describe 'name not given' do
        before { create_with_node() }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'inner_nodes[0].name', message: 'required'})
        end
      end

      describe 'name too short' do
        before { create_with_node({name: 'a'}) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'inner_nodes[0].name', message: 'length'})
        end
      end

      describe 'factory not given' do
        before { create_with_node({name: 'test'}) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'inner_nodes[0].factory', message: 'required'})
        end
      end

      describe 'factory not given' do
        before { create_with_node({name: 'test', factory: 'a'}) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'inner_nodes[0].factory', message: 'length'})
        end
      end
    end

    describe 'Inner links error cases' do
      def create_with_link(payload = {})
        create({
          name: 'test',
          slots: 10,
          inner_nodes: [{name: 'foo', factory: 'bar'}],
          inner_links: [payload]
        })
      end

      describe 'The origin is not given at all' do
        before { create_with_link({}) }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'inner_links[0].from', message: 'required'
          )
        end
      end

      describe 'The origin node is not given' do
        before { create_with_link({from: {}}) }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'inner_links[0].from.node', message: 'required'
          )
        end
      end

      describe 'The origin index is not given' do
        before { create_with_link({from: {node: 'foo'}}) }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'inner_links[0].from.index', message: 'required'
          )
        end
      end

      describe 'The origin node is not in the inner nodes' do
        before { create_with_link({from: {node: 'baz', index: 0}, to: {node: 'foo', index: 0}}) }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 404
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'inner_links[0].from.node', message: 'unknown'
          )
        end
      end

      describe 'The destination is not given at all' do
        before { create_with_link({from: { node: 'foo', index: 0 }}) }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'inner_links[0].to', message: 'required'
          )
        end
      end

      describe 'The destination node is not given' do
        before { create_with_link({from: { node: 'foo', index: 0 }, to: {}}) }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'inner_links[0].to.node', message: 'required'
          )
        end
      end

      describe 'The destination index is not given' do
        before { create_with_link({from: {node: 'foo', index: 0}, to: {node: 'foo'}}) }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'inner_links[0].to.index', message: 'required'
          )
        end
      end

      describe 'The destination node is not in the inner nodes' do
        before { create_with_link({from: {node: 'foo', index: 0}, to: {node: 'baz', index: 0}}) }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 404
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'inner_links[0].to.node', message: 'unknown'
          )
        end
      end
    end
  end
end
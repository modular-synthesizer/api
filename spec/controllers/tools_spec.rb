RSpec.describe Modusynth::Controllers::Tools do
  def app
    Modusynth::Controllers::Tools
  end

  def create_tool
    parameter = Modusynth::Services::Parameters.instance.create(
      'name' => 'frequency',
      'default' => 440,
      'minimum' => 20,
      'maximum' => 2020,
      'step' => 1,
      'precision' => 0
    )
    Modusynth::Services::Tools.instance.create(
      'name' => 'VCA',
      'slots' => 3,
      'innerNodes' => [
        {'name' => 'gain', 'generator' => 'GainNode'}
      ],
      'parameters' => [
        {'descriptor' => parameter.id.to_s, 'targets' => ['gain']}
      ],
      'innerLinks' => [],
      'inputs' => [
        {'name' => 'INPUT', 'index' => 0, 'targets' => ['gain']}
      ],
      'outputs' => [
        {'name' => 'INPUT', 'index' => 0, 'targets' => ['gain']}
      ]
    )
  end

  describe 'GET /' do
    describe 'empty list' do
      before { get '/' }

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'returns an empty list when nothing has been created' do
        expect(last_response.body).to include_json({tools: []})
      end
    end

    describe 'not empty list' do
      let!(:tool) { create_tool }
      before { get '/' }
      
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(JSON.parse(last_response.body)).to eq({
          'tools' => [
            {'id' => tool.id.to_s, 'name' => 'VCA'}
          ]
        })
      end
    end

  end

  describe 'GET /:id' do

    describe 'Nominal case' do
      let!(:tool) { create_tool }

      before do
        get "/#{tool.id.to_s}"
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          id: tool.id.to_s,
          name: 'VCA',
          innerNodes: [
            {name: 'gain', generator: 'GainNode'}
          ],
          parameters: [
            {
              name: 'frequency',
              value: 440,
              constraints: {
                minimum: 20,
                maximum: 2020,
                step: 1,
                precision: 0
              },
              targets: ['gain']
            }
          ],
          innerLinks: [],
          inputs: [
            {name: 'INPUT', index: 0, targets: ['gain']}
          ],
          outputs: [
            {name: 'INPUT', index: 0, targets: ['gain']}
          ]
        })
      end
    end
  end

  describe 'POST /' do
    describe 'Nominal case' do
      before { create_simple_tool }

      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: Modusynth::Models::Tool.first.id.to_s,
          name: 'VCA',
          slots: 3,
          innerNodes: [],
          innerLinks: [],
          inputs: [],
          outputs: []
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
        before { create_tool_with_inner_node }

        it 'Returns a 201 (Created) status code' do
          expect(last_response.status).to be 201
        end
        it 'Returns the correct body' do
          creation = Modusynth::Models::Tool.first
          expect(last_response.body).to include_json(
            id: creation.id.to_s,
            name: 'VCA',
            slots: 3,
            innerNodes: [{
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
      describe 'Tool with inner links' do
        before { create_tool_with_inner_link }

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
        before { create_tool_with_parameter param }

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
      describe 'Tool with inputs' do
        before { create_tool_with_input }

        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            id: Modusynth::Models::Tool.first.id.to_s,
            name: 'VCA',
            slots: 3,
            innerNodes: [],
            innerLinks: [],
            inputs: [{name: 'INPUT', index: 0, targets: ['gain']}],
            outputs: []
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
            expect(input.targets).to eq ['gain']
          end
          it 'Has created a port with the correct index' do
            expect(input.index).to be 0
          end
        end
      end
      describe 'Tool with outputs' do
        before { create_tool_with_output }

        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            id: Modusynth::Models::Tool.first.id.to_s,
            name: 'VCA',
            slots: 3,
            innerNodes: [],
            innerLinks: [],
            outputs: [{name: 'OUTPUT', index: 0, targets: ['gain']}],
            inputs: []
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
            expect(output.targets).to eq ['gain']
          end
          it 'Has created a port with the correct index' do
            expect(output.index).to be 0
          end
        end
      end
    end

    describe 'Error cases' do
      describe 'No name given' do
        before { create_empty_tool }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'name', message: 'required'})
        end
      end

      describe 'Name too short' do
        before { create_empty_tool({name: 'a'}) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'name', message: 'length'})
        end
      end

      describe 'Slots not given' do
        before { create_empty_tool({name: 'test'}) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'slots', message: 'required'})
        end
      end

      describe 'Slots given with negative value' do
        before { create_empty_tool({name: 'test', slots: -1}) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'slots', message: 'value'})
        end
      end

      describe 'Slots given with zero as value' do
        before { create_empty_tool({name: 'test', slots: 0}) }

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
        create_empty_tool({name: 'test', slots: 10, innerNodes: [payload]})
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

      describe 'generator not given' do
        before { create_with_node({name: 'test'}) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'inner_nodes[0].generator', message: 'required'})
        end
      end

      describe 'generator name too short' do
        before { create_with_node({name: 'test', generator: 'a'}) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'inner_nodes[0].generator', message: 'length'})
        end
      end
    end

    describe 'Inner links error cases' do
      def create_with_link(payload = {})
        create_empty_tool({
          name: 'test',
          slots: 10,
          innerNodes: [{name: 'foo', generator: 'bar'}],
          innerLinks: [payload]
        })
      end

      describe 'The origin is not given at all' do
        before { create_with_link({}) }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'innerLinks[0].from', message: 'required'
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
            key: 'innerLinks[0].from.node', message: 'required'
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
            key: 'innerLinks[0].from.index', message: 'required'
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
            key: 'innerLinks[0].from.node', message: 'unknown'
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
            key: 'innerLinks[0].to', message: 'required'
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
            key: 'innerLinks[0].to.node', message: 'required'
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
            key: 'innerLinks[0].to.index', message: 'required'
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
            key: 'innerLinks[0].to.node', message: 'unknown'
          )
        end
      end
    end

    describe 'parameters error cases' do
      before do
        create_empty_tool({
          name: 'test',
          slots: 10,
          parameters: [ {descriptor: 'unknown_id'} ]
        })
      end

      it 'Returns a 404 (Unknown) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          key: 'parameters[0]', message: 'unknown'
        })
      end
    end

    describe 'inputs error cases' do

      def create_with_input payload
        create_empty_tool({name: 'test', slots: 10, inputs: [payload], innerNodes: [{name: 'test', generator: 'test'}]})
      end

      describe 'The name is not given' do
        before { create_with_input({}) }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json({
            key: 'ports[0].name', message: 'required'
          })
        end
      end
      describe 'The name is too short' do
        before { create_with_input({name: 'a'}) }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json({
            key: 'ports[0].name', message: 'length'
          })
        end
      end
      describe 'An index is below zero' do
        before { create_with_input({name: 'foo', targets: [], index: -1}) }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json({
            key: 'ports[0].index', message: 'value'
          })
        end
      end
    end

    describe 'outputs error cases' do

      def create_with_output payload
        create_empty_tool({
          name: 'test',
          slots: 10,
          outputs: [payload],
          innerNodes: [{name: 'test', generator: 'test'}]
        })
      end

      describe 'The name is not given' do
        before { create_with_output({}) }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json({
            key: 'ports[0].name', message: 'required'
          })
        end
      end
      describe 'The name is too short' do
        before { create_with_output({name: 'a'}) }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json({
            key: 'ports[0].name', message: 'length'
          })
        end
      end
      describe 'An index is below zero' do
        before { create_with_output({name: 'foo', targets: [], index: -1}) }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json({
            key: 'ports[0].index', message: 'value'
          })
        end
      end
    end
  end
end
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

    describe 'Nominal case' do
      before { create_simple_tool(session) }

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
        before { create_tool_with_inner_node(session) }

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
        before { create_tool_with_inner_link(session) }

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
        before { create_tool_with_parameter(session, param) }

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
        before { create_tool_with_input(session) }

        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            id: Modusynth::Models::Tool.first.id.to_s,
            name: 'VCA',
            slots: 3,
            innerNodes: [],
            innerLinks: [],
            inputs: [{name: 'INPUT', index: 0, target: 'gain'}],
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
            expect(input.target).to eq 'gain'
          end
          it 'Has created a port with the correct index' do
            expect(input.index).to be 0
          end
        end
      end
      describe 'Tool with outputs' do
        before { create_tool_with_output(session) }

        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            id: Modusynth::Models::Tool.first.id.to_s,
            name: 'VCA',
            slots: 3,
            innerNodes: [],
            innerLinks: [],
            outputs: [{name: 'OUTPUT', index: 0, target: 'gain'}],
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
        before { create_empty_tool(session) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'name', message: 'required'})
        end
        include_examples 'empty lists'
      end

      describe 'Name too short' do
        before { create_empty_tool(session, {name: 'a'}) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'name', message: 'length'})
        end
        include_examples 'empty lists'
      end

      describe 'Slots not given' do
        before { create_empty_tool(session, {name: 'test'}) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'slots', message: 'required'})
        end
        include_examples 'empty lists'
      end

      describe 'Slots given with negative value' do
        before { create_empty_tool(session, {name: 'test', slots: -1}) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'slots', message: 'value'})
        end
        include_examples 'empty lists'
      end

      describe 'Slots given with zero as value' do
        before { create_empty_tool(session, {name: 'test', slots: 0}) }

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

      def create_with_node(session, payload = {})
        create_empty_tool(session, {name: 'test', slots: 10, innerNodes: [payload]})
      end

      describe 'name not given' do
        before { create_with_node(session) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'inner_nodes[0].name', message: 'required'})
        end
        include_examples 'empty lists'
      end

      describe 'name too short' do
        before { create_with_node(session, {name: 'a'}) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'inner_nodes[0].name', message: 'length'})
        end
        include_examples 'empty lists'
      end

      describe 'generator not given' do
        before { create_with_node(session, {name: 'test'}) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'inner_nodes[0].generator', message: 'required'})
        end
        include_examples 'empty lists'
      end

      describe 'generator name too short' do
        before { create_with_node(session, {name: 'test', generator: 'a'}) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'inner_nodes[0].generator', message: 'length'})
        end
        include_examples 'empty lists'
      end
    end

    describe 'Inner links error cases' do
      def create_with_link(payload = {})
        create_empty_tool(session, {
          name: 'test',
          slots: 10,
          innerNodes: [{name: 'foo', generator: 'bar'}],
          innerLinks: [payload]
        })
      end

      describe 'The origin is not given' do
        before { create_with_link({}) }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'innerLinks[0].from', message: 'required'
          )
        end
        include_examples 'empty lists'
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
        include_examples 'empty lists'
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
        include_examples 'empty lists'
      end

      describe 'The destination is not given' do
        before { create_with_link({from: { node: 'foo', index: 0 }}) }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'innerLinks[0].to', message: 'required'
          )
        end
        include_examples 'empty lists'
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
        include_examples 'empty lists'
      end
    end

    describe 'parameters error cases' do
      before do
        create_empty_tool(session, {
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
      include_examples 'empty lists'
    end

    describe 'inputs error cases' do

      def create_with_input *payload
        create_empty_tool(session, {
          name: 'test',
          slots: 10,
          inputs: [{name: 'test', targets: [], index: 0}] + payload,
          innerNodes: [{name: 'test', generator: 'test'}]})
      end

      describe 'The name is not given' do
        before { create_with_input({}) }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json({
            key: 'ports[1].name', message: 'required'
          })
        end
        include_examples 'empty lists'
      end
      describe 'The name is too short' do
        before { create_with_input({name: 'a'}) }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json({
            key: 'ports[1].name', message: 'length'
          })
        end
        include_examples 'empty lists'
      end
      describe 'An index is below zero' do
        before { create_with_input({name: 'foo', targets: [], index: -1}) }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json({
            key: 'ports[1].index', message: 'value'
          })
        end
        include_examples 'empty lists'
      end
    end

    describe 'outputs error cases' do

      def create_with_output payload
        create_empty_tool(session, {
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
        include_examples 'empty lists'
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
        include_examples 'empty lists'
      end
      describe 'An index is below zero' do
        before { create_with_output({name: 'foo', target: 'test', index: -1}) }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json({
            key: 'ports[0].index', message: 'value'
          })
        end
        include_examples 'empty lists'
      end
    end

    include_examples 'admin', 'post', '/'
  end
end
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
    describe "Update the ports list" do
      # We first create a tool with the desired ports
      let!(:input) { build(:input_port, name: 'INPUT1') }
      let!(:output) { build(:output_port, name: 'OUTPUT1') }
      let!(:other_output) { build(:output_port, name: 'OUTPUT2') }
      let!(:ports_tool) {
        tool = create(:tool, category: dopefun, ports: [ input, output, other_output ])
        tool.ports.map(&:save!)
        tool
      }
      # We then instanciate the tool in a synthesizer
      let!(:synthesizer) { create(:synthesizer, account:) }
      let!(:mod) { create(:module, tool: ports_tool, synthesizer:) }
      # Lastly, we create the links from the ports in the mod
      # We affect variables for the mod ports so that we can manipulate them in specs
      let!(:m_input) { mod.ports.where(descriptor: input).first }
      let!(:m_output) { mod.ports.where(descriptor: output).first }
      let!(:m_other_output) { mod.ports.where(descriptor: other_output).first }
      let!(:link) { create(:link, from: m_input, to: m_output, synthesizer:) }
      let!(:other_link) { create(:link, from: m_input, to: m_other_output, synthesizer:) }

      before do
        put "/#{ports_tool.id.to_s}", {
          auth_token: session.token,
          ports: [
            {name: 'INPUT2', kind: 'input', target: 'any_target', index: 0},
            {id: other_output.id.to_s},
            {id: input.id.to_s}
          ]
        }.to_json
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          ports: [
            {name: 'INPUT1'},
            {name: 'OUTPUT2'},
            {name: 'INPUT2'}
          ]
        )
      end
      describe 'The updated tool' do
        let!(:reload) { ports_tool.reload }

        it 'Has deleted the output port' do
          expect(ports_tool.ports.where(name: 'OUTPUT1').first).to be_nil
        end
        it 'Has not deleted the output port' do
          expect(ports_tool.ports.where(name: 'OUTPUT2').count).to be 1
        end
        it 'Has created the second input port' do
          expect(ports_tool.ports.where(name: 'INPUT2').count).to be 1
        end
        it 'Has not deleted the link that should not be deleted' do
          expect(Modusynth::Models::Link.where(to: m_output).count).to be 0
        end
        it 'Has deleted the other link' do
          expect(Modusynth::Models::Link.where(to: m_other_output).count).to be 1
        end
      end
    end
    describe 'Update the parameters list' do
      let!(:synthesizer) { create(:synthesizer, account:) }
      let!(:mod) { create(:module, tool: tool, synthesizer:) }
      let!(:descriptor) { Modusynth::Models::Tools::Descriptor.first }

      before do
        put "/#{tool.id.to_s}", {
          auth_token: session.token,
          parameters: [{descriptorId: descriptor.id.to_s, targets: ['target'], name: 'testparam'}]
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          parameters: [ {name: 'testparam'} ]
        )
      end
      describe 'The updated parameters' do
        before do
          tool.reload
        end
        it 'Has not created more parameters' do
          expect(tool.parameters.count).to be 1
        end
        it 'Has created the correzct parameter' do
          expect(tool.parameters.first.name).to eq 'testparam'
        end
        it 'Has deleted the parameter from the module' do
          expect(mod.parameters.count).to be 1
        end
        it 'Has created the parameter in the module with the correct descriptor' do
          expect(mod.parameters.first.parameter.descriptor.id.to_s).to eq descriptor.id.to_s
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
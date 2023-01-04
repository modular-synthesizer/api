RSpec.describe 'Tool creation service' do
  let!(:service) { Modusynth::Services::Tools::Create.instance }

  describe 'Nominal case' do
    let!(:creation) { service.create(name: 'TestTool', slots: 10) }

    it 'Has returned a persisted object' do
      expect(creation.persisted?).to be_truthy
    end
    it 'Has returned an object with the correct name' do
      expect(creation.name).to eq 'TestTool'
    end
    it 'Has returned an object with the correct number of slots' do
      expect(creation.slots).to be 10
    end
  end

  describe 'Error cases' do
    describe 'With an invalid inner node' do
      let!(:payload) do
        {name: 'TestTool', slots: 10, nodes: [{name: 'test-node', generator: 'fo'}]}
      end
      it 'Returns the correct kind of exception' do
        expect { service.build_and_validate!(**payload) }.to raise_error(
          Modusynth::Exceptions::Validation
        )
      end
      it 'Has the correct messages' do
        begin
          service.build_and_validate!(**payload)
        rescue Modusynth::Exceptions::Validation => exception
          expect(exception.messages).to eq({:'nodes[0].generator' => ['length']})
        end
      end
    end
    describe 'With an invalid inner link' do
      it 'Returns an error with the first key in error' do
        inner_link = {from: {node: 'test', index: 0}, to: { node: 'test', index: -1 }}
        payload = {name: 'TestTool', slots: 10, links: [inner_link]}
        expect { service.build_and_validate!(**payload) }.to raise_error(
          Modusynth::Exceptions::Validation
        )
      end
    end
  end
end
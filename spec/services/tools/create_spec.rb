RSpec.describe 'Tool creation service' do
  let!(:service) { Modusynth::Services::Tools::Create.instance }
  let!(:dopefun) { create(:dopefun) }

  describe 'Nominal case' do
    let!(:creation) { service.create(name: 'TestTool', slots: 10, categoryId: dopefun.id.to_s) }

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
        {
          name: 'TestTool',
          slots: 10,
          categoryId: dopefun.id.to_s,
          nodes: [{name: 'test-node', generator: 'fo'}]
        }
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
      let!(:payload) do
        {
          name: 'TestTool',
          slots: 10,
          categoryId: dopefun.id.to_s,
          links: [
            {from: {node: 'test', index: 0}, to: { node: 'test', index: -1 }}
          ]
        }
      end
      it 'Returns an error with the first key in error' do
        expect { service.build_and_validate!(**payload) }.to raise_error(
          Modusynth::Exceptions::Validation
        )
      end
      it 'Has the correct message' do
        begin
          service.build_and_validate!(**payload)
        rescue Modusynth::Exceptions::Validation => exception
          expect(exception.messages).to eq({:'links[0].to.index' => ['value']})
        end
      end
    end
    describe 'With an invalid port' do
      let!(:payload) do
        {
          name: 'TestTool',
          slots: 10,
          categoryId: dopefun.id.to_s,
          ports: [{name: nil, kind: 'input', target: 'test', index: 0}]
        }
      end
      it 'Returns an error with the first key in error' do
        expect { service.build_and_validate!(**payload) }.to raise_error(
          Modusynth::Exceptions::Validation
        )
      end
      it 'Has the correct message' do
        begin
          service.build_and_validate!(**payload)
        rescue Modusynth::Exceptions::Validation => exception
          expect(exception.messages).to eq({:'ports[0].name' => ['required']})
        end
      end
    end
    describe 'With an invalid category UUID' do
      let!(:payload) do
        {name: 'TestTool', slots: 10, categoryId: 'invalid'}
      end
      it 'Returns an error with the first key in error' do
        expect { service.build_and_validate!(**payload) }.to raise_error(
          Modusynth::Exceptions::Unknown
        )
      end
      it 'Has the correct attributes' do
        begin
          service.build_and_validate!(**payload)
        rescue Modusynth::Exceptions::Unknown => exception
          expect(exception.key).to eq 'categoryId'
          expect(exception.error).to eq 'unknown'
        end
      end
    end
  end
end
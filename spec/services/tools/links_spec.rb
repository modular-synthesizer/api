RSpec.describe 'Inner links service' do
  let!(:service) { Modusynth::Services::Tools::Links.instance }

  describe 'build' do
    describe 'Nominal case' do
      let!(:payload) {
        {from: {node: 'origin', index: 0}, to: {node: 'destination', index: 1}}
      }
      let!(:result) { service.build(index: 0, **payload) }

      it 'Correctly sets the origin node' do
        expect(result.from.node).to eq 'origin'
      end
      it 'Correctly sets the origin index' do
        expect(result.from.index).to be 0
      end
      it 'Correctly sets the destination node' do
        expect(result.to.node).to eq 'destination'
      end
      it 'Correctly sets the destination index' do
        expect(result.to.index).to be 1
      end
    end
  end

  describe 'validate!' do
    describe 'Validation nominal case' do
      it 'Does not raise any error when the payload is correct' do
        payload = {from: {node: 'test', index: 0}, to: {node: 'test', index: 0}}
        expect { service.validate!(index: 0, **payload)}.to_not raise_error
      end
    end

    describe 'validation errors' do
      it 'Raises an error if the origin is nil' do
        payload = {from: {node: 'test', index: 0}}
        expect { service.validate!(index: 0, **payload)}.to raise_error(
          Modusynth::Exceptions::BadRequest
        )
      end
      it 'Raises an error if the destination is nil' do
        payload = {to: {node: 'test', index: 0}}
        expect { service.validate!(index: 0, **payload)}.to raise_error(
          Modusynth::Exceptions::BadRequest
        )
      end
      it 'Raises an error if the origin node is not given' do
        payload = {from: {index: 0}, to: {node: 'test', index: 0}}
        expect { service.validate!(index: 0, **payload)}.to raise_error(
          Modusynth::Exceptions::Validation
        )
      end
      it 'Raises an error if the destination node is not given' do
        payload = {from: {node: 'test', index: 0}, to: {index: 0}}
        expect { service.validate!(index: 0, **payload)}.to raise_error(
          Modusynth::Exceptions::Validation
        )
      end
      it 'Raises an error if the origin index is not given' do
        payload = {from: {node: 'test'}, to: {node: 'test', index: 0}}
        expect { service.validate!(index: 0, **payload)}.to raise_error(
          Modusynth::Exceptions::Validation
        )
      end
      it 'Raises an error if the destination index is not given' do
        payload = {from: {node: 'test', index: 0}, to: {node: 'test'}}
        expect { service.validate!(index: 0, **payload)}.to raise_error(
          Modusynth::Exceptions::Validation
        )
      end
      it 'Raises an error if the origin index is below zero' do
        payload = {from: {node: 'test', index: -1}, to: {node: 'test', index: 0}}
        expect { service.validate!(index: 0, **payload)}.to raise_error(
          Modusynth::Exceptions::Validation
        )
      end
      it 'Raises an error if the destination index is below zero' do
        payload = {from: {node: 'test', index: 0}, to: {node: 'test', index: -1}}
        expect { service.validate!(index: 0, **payload)}.to raise_error(
          Modusynth::Exceptions::Validation
        )
      end
    end
  end
end
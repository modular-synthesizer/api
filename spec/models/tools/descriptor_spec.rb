RSpec.describe Modusynth::Models::Tools::Descriptor do
  let!(:model) { Modusynth::Models::Tools::Descriptor }

  describe 'Nominal case' do
    let!(:descriptor) do
      model.new(
        name: 'test',
        minimum: 0,
        maximum: 10,
        step: 1,
        default: 1,
        precision: 0
      )
    end
    it 'Validates the descriptor' do
      expect(descriptor.valid?).to be_truthy
    end
  end
  describe 'Error cases' do
    describe 'Fields not given' do
      let!(:descriptor) do
        desc = model.new
        desc.validate
        desc
      end
      let!(:errors) { descriptor.errors.messages }

      it 'Invalidates the descriptor' do
        expect(descriptor.valid?).to be_falsy
      end

      describe 'When the name is not given' do
        it 'Returns the correct error message' do
          expect(errors[:name]).to eq ['required']
        end
      end
      describe 'When the minimum is not given' do
        it 'Returns the correct error message' do
          expect(errors[:minimum]).to eq ['required']
        end
      end
      describe 'When the maximum is not given' do
        it 'Returns the correct error message' do
          expect(errors[:maximum]).to eq ['required']
        end
      end
      describe 'When the step attribute is not given' do
        it 'Returns the correct error message' do
          expect(errors[:step]).to eq ['required']
        end
      end
      describe 'When the precision is not given' do
        it 'Returns the correct error message' do
          expect(errors[:precision]).to eq ['required']
        end
      end
    end
    describe 'When the minimum is above the maximum' do
      let!(:descriptor) { model.new(name: 'test', minimum: 10, maximum: 0, step: 1, precision: 0, default: 5) }

      it 'Invalidates the record' do
        expect(descriptor.valid?).to be_falsy
      end
      it 'Returns the correct message' do
        descriptor.validate
        expect(descriptor.errors.messages[:boundaries]).to eq ['order']
      end
    end
    describe 'When the default value is not in the boundaries' do
      let!(:descriptor) { model.new(name: 'test', minimum: 0, maximum: 10, step: 1, precision: 0, default: 15) }

      it 'Invalidates the record' do
        expect(descriptor.valid?).to be_falsy
      end
      it 'Returns the correct message' do
        descriptor.validate
        expect(descriptor.errors.messages[:default]).to eq ['value']
      end
    end
  end
end
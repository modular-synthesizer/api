RSpec.describe Modusynth::Models::Tool do
  let!(:model) { Modusynth::Models::Tool }

  describe 'Nominal case' do
    let!(:tool) { model.new(name: 'test', slots: 10) }

    it 'Validates the record' do
      expect(tool.valid?).to be_truthy
    end
  end

  describe 'Error cases' do
    describe 'When the name is not given' do
      let!(:tool) { model.new(slots: 10) }

      it 'Invalidates the record' do
        expect(tool.valid?).to be_falsy
      end
      it 'Returns the correct error message' do
        tool.validate
        expect(tool.errors.messages[:name]).to eq ['required']
      end
    end
    describe 'When the name is too short' do
      let!(:tool) { model.new(name: 'a', slots: 10) }
      
      it 'Invalidates the record' do
        expect(tool.valid?).to be_falsy
      end
      it 'Returns the correct error message' do
        tool.validate
        expect(tool.errors.messages[:name]).to eq ['minlength']
      end
    end
    describe 'When the slots are not given' do
      let!(:tool) { model.new(name: 'test') }
      
      it 'Invalidates the record' do
        expect(tool.valid?).to be_falsy
      end
      it 'Returns the correct error message' do
        tool.validate
        expect(tool.errors.messages[:slots]).to eq ['required']
      end
    end
    describe 'When the slots are zero' do
      let!(:tool) { model.new(name: 'test', slots: 0) }
      
      it 'Invalidates the record' do
        expect(tool.valid?).to be_falsy
      end
      it 'Returns the correct error message' do
        tool.validate
        expect(tool.errors.messages[:slots]).to eq ['value']
      end
    end
    describe 'When the slots are below zero' do
      let!(:tool) { model.new(name: 'test', slots: -1) }
      
      it 'Invalidates the record' do
        expect(tool.valid?).to be_falsy
      end
      it 'Returns the correct error message' do
        tool.validate
        expect(tool.errors.messages[:slots]).to eq ['value']
      end
    end
  end
end
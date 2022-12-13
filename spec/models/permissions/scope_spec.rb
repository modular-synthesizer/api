RSpec.describe Modusynth::Models::Permissions::Scope do
  describe :label do
    let!(:model) { Modusynth::Models::Permissions::Scope }

    describe 'Valid record' do
      it 'Validates a correctly initialized record' do
        expect(model.new(label: 'Accounts::List_all').valid?).to be true
      end
    end
    describe 'label not given' do
      let!(:instance) { model.new }

      it 'Invalidates a record without slug' do
        expect(instance.valid?).to be false
      end
      it 'Returns the correct error message' do
        instance.validate
        expect(instance.errors.messages).to eq({label: ['required']})
      end
    end
    describe 'label given as nil' do
      let!(:instance) { model.new(label: nil) }
      
      it 'Invalidates a record without slug' do
        expect(instance.valid?).to be false
      end
      it 'Returns the correct error message' do
        instance.validate
        expect(instance.errors.messages).to eq({label: ['required']})
      end
    end
    describe 'label with a wrong format' do
      let!(:instance) { model.new(label: 'test-false-format') }
      
      it 'Invalidates a record without slug' do
        expect(instance.valid?).to be false
      end
      it 'Returns the correct error message' do
        instance.validate
        expect(instance.errors.messages).to eq({label: ['format']})
      end
    end
    describe 'label too short' do
      let!(:instance) { model.new(label: 'foo') }
      
      it 'Invalidates a record without slug' do
        expect(instance.valid?).to be false
      end
      it 'Returns the correct error message' do
        instance.validate
        expect(instance.errors.messages).to eq({label: ['minlength']})
      end
    end
    describe 'label not uniq' do
      let!(:first) { model.create(label: 'Accounts::List_all') }
      let!(:instance) { model.new(label: 'Accounts::List_all') }
      
      it 'Invalidates a record without slug' do
        expect(instance.valid?).to be false
      end
      it 'Returns the correct error message' do
        instance.validate
        expect(instance.errors.messages).to eq({label: ['uniq']})
      end
    end
  end
end
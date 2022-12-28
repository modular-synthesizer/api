RSpec.describe Modusynth::Models::Permissions::Group do
  describe :slug do
    let!(:model) { Modusynth::Models::Permissions::Group }

    describe 'Valid record' do
      it 'Validates a correctly initialized record' do
        expect(model.new(slug: 'test-slug').valid?).to be true
      end
    end
    describe 'Slug not given' do
      let!(:instance) { model.new }

      it 'Invalidates a record without slug' do
        expect(instance.valid?).to be false
      end
      it 'Returns the correct error message' do
        instance.validate
        expect(instance.errors.messages).to eq({slug: ['required']})
      end
    end
    describe 'Slug given as nil' do
      let!(:instance) { model.new(slug: nil) }
      
      it 'Invalidates a record without slug' do
        expect(instance.valid?).to be false
      end
      it 'Returns the correct error message' do
        instance.validate
        expect(instance.errors.messages).to eq({slug: ['required']})
      end
    end
    describe 'Slug with a wrong format' do
      let!(:instance) { model.new(slug: '12345<67890') }
      
      it 'Invalidates a record without slug' do
        expect(instance.valid?).to be false
      end
      it 'Returns the correct error message' do
        instance.validate
        expect(instance.errors.messages).to eq({slug: ['format']})
      end
    end
    describe 'slug too short' do
      let!(:instance) { model.new(slug: 'foo') }
      
      it 'Invalidates a record without slug' do
        expect(instance.valid?).to be false
      end
      it 'Returns the correct error message' do
        instance.validate
        expect(instance.errors.messages).to eq({slug: ['minlength']})
      end
    end
    describe 'slug not uniq' do
      let!(:first) { model.create(slug: 'new-group') }
      let!(:instance) { model.new(slug: 'new-group') }
      
      it 'Invalidates a record without slug' do
        expect(instance.valid?).to be false
      end
      it 'Returns the correct error message' do
        instance.validate
        expect(instance.errors.messages).to eq({slug: ['uniq']})
      end
    end
  end
end
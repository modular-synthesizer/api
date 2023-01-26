RSpec.describe Modusynth::Services::Permissions::Groups do
  let!(:service) { Modusynth::Services::Permissions::Groups.instance }
  let!(:model) { Modusynth::Models::Permissions::Group }

  describe :create do
    describe 'Nominal case' do
      let!(:creation) { service.create(slug: 'custom-slug') }
      it 'Creates the group if the slug is correct' do
        expect(creation.persisted?).to be true
      end
      it 'Has created the group with the correct slug' do
        expect(creation.slug).to eq 'custom-slug'
      end
    end
    it 'Raises an exception if the slug is not given' do
      expect(->{ service.create(slug: nil) }).to raise_error(
        Mongoid::Errors::Validations
      )
    end
    it 'Raises an exception if the slug is not correct' do
      expect(->{ service.create(slug: 'invalid_slug_123') }).to raise_error(
        Mongoid::Errors::Validations
      )
    end
    it 'Raises an exception if a scope is not found' do
      expect { service.create(slug: 'custom-slug', scopes: ['unknown']) }.to raise_error(
        an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'scopes[0]', error: 'unknown', prefix: '')
      )
    end
  end
  describe :delete do
    let!(:group) { service.create(slug: 'custom-deletion') }

    describe 'Nominal case' do
      let!(:result) { service.remove(id: group.id) }
      
      it 'Returns the correct result' do
        expect(result).to be true
      end
      it 'Correctly destroys an existing record' do
        expect(Modusynth::Models::Permissions::Group.where(slug: 'custom-deletion').count).to be 0
      end
    end
    it 'does not fail when deleting a non existing record' do
      expect(service.remove(id: 'any id')).to be false
    end
  end
  describe :find_or_fail do
    let!(:group) { model.create(slug: 'my-custom-group') }

    it 'Returns the correct record if it is found' do
      expect(service.find_or_fail(id: group.id).slug).to eq 'my-custom-group'
    end
    it 'Raises an exception if the record is not found' do
      expect(->{ service.find_or_fail(id: 'any_id') }).to raise_error Modusynth::Exceptions::Unknown
    end
  end
  describe :list do
    let!(:first) { model.create(slug: 'first-slug') }
    let!(:second) { model.create(slug: 'custom-slug') }

    it 'Returns the correct list in the correct order' do
      expect(service.list).to eq [second, first]
    end
  end
  describe :update do
    let!(:creation) { service.create(slug: 'update-slug') }

    it 'Correctly update the slug if a correct value is provided' do
      expect(service.find_and_update(id: creation.id, slug: 'new-slug').slug).to eq 'new-slug'
    end
    it 'Does not update the group if the slug is given as nil' do
      expect(->{ service.find_and_update(id: creation.id, slug: nil) }).to raise_error(
        Mongoid::Errors::Validations
      )
    end
    it 'Does not update the group if the slug is incorrect' do
      expect(->{ service.find_and_update(id: creation.id, slug: 'slug_123') }).to raise_error(
        Mongoid::Errors::Validations
      )
    end
    it 'Does not update the group if a scope is not found' do
      expect { service.find_and_update(id: creation.id, scopes: ['unknown']) }.to raise_error(
        Modusynth::Exceptions::Unknown
      )
    end
  end
end
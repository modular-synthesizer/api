RSpec.describe Modusynth::Services::Permissions::Groups do
  let!(:service) { Modusynth::Services::Permissions::Groups.instance }
  let!(:model) { Modusynth::Models::Permissions::Group }

  describe :create do

  end
  describe :delete do

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

  end
  describe :update do

  end
end
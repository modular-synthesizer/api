RSpec.describe do
  let!(:service) { Modusynth::Services::Permissions::Rights.instance }
  describe :create do
    describe 'Nominal case' do
      let!(:creation) { service.create(label: 'Category::Tests') }

      it 'has created the record in the database' do
        expect(creation.persisted?).to be true
      end
      it 'has created the record with the correct label' do
        expect(creation.label).to eq 'Category::Tests'
      end
    end
    it 'Raises an exception when the label is not given' do
      expect { service.create(label: nil) }.to raise_error(
        Mongoid::Errors::Validations
      )
    end
    it 'Raises an exception when the label is too short' do
      expect { service.create(label: 'A::B') }.to raise_exception(
        Mongoid::Errors::Validations
      )
    end
    it 'Raises an exception when the label does not have the correct format' do
      expect { service.create(label: 'patate123') }.to raise_error(
        Mongoid::Errors::Validations
      )
    end
  end
  describe :delete do
    let!(:creation) { service.create(label: 'Category::Tests') }

    describe 'Nominal case' do
      let!(:result) { service.remove(id: creation.id.to_s) }
      it 'Returns the correct result' do
        expect(result).to be true
      end
      it 'Correctly deletes an existing record' do
        expect(Modusynth::Models::Permissions::Right.all.count).to be 0
      end
    end
    it 'Returns the correct result if the UUID does not exist' do
      expect(service.remove(id: 'unknown')).to be false
    end
  end
  describe :find_or_fail do
    let!(:scope) { service.create(label: 'Tests::Creation') }

    it 'Returns the correct results' do
      expect(service.find_or_fail(id: scope.id).id).to eq scope.id
    end
    it 'Raises an error if the record does not exist' do
      expect { service.find_or_fail(id: 'unknown') }.to raise_error(
        Modusynth::Exceptions::Unknown
      )
    end
  end
  describe :list do
    describe 'Nominal case' do
      let!(:first_scope) { create(:scope, label: 'Tests::Ab') }
      let!(:second_scope) { create(:scope, label: 'Tests::Aa') }

      it 'Returns a sorted list of scopes' do
        expect(service.list.map(&:id)).to eq [second_scope.id, first_scope.id]
      end
    end
    describe 'When the list is empty' do
      it 'Returns an empty list of scopes' do
        expect(service.list).to eq []
      end
    end
  end
end
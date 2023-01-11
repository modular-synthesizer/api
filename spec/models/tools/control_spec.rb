RSpec.describe Modusynth::Models::Tools::Control do
  let!(:model) { Modusynth::Models::Tools::Control }

  describe 'Nominal case' do
    let!(:control) do
      model.new(
        component: 'CustomControl',
        payload: { x: 20, label: 'test', displayLabel: true  }
      )
    end
    it 'validates the record if every information is given' do
      expect(control.valid?).to be_truthy
    end
    it 'Returns the correct component' do
      expect(control.component).to eq 'CustomControl'
    end
    describe 'payload' do
      let!(:payload) { control.payload }

      it 'Returns integer values' do
        expect(payload[:x]).to be 20
      end
      it 'Returns boolean values' do
        expect(payload[:displayLabel]).to be_truthy
      end
      it 'Returns string values' do
        expect(payload[:label]).to eq 'test'
      end
    end
  end
  describe 'Error cases' do
    describe 'When the component is not given' do
      it 'Does not validate the control if the component is not given' do
        expect(model.new.valid?).to be_falsy
      end
    end
    describe 'When the component is given as nil' do
      it 'Invalidates the control if the component is nil' do
        expect(model.new(component: nil).valid?).to be_falsy
      end
    end
    describe 'When the component does not have the correct format' do
      it 'Invalidates the record if the component starts with a lowercase letter' do
        expect(model.new(component: 'testComponent').valid?).to be_falsy
      end
      it 'Invalidates the record if there is something else than alphabetic characters in it' do
        expect(model.new(component: 'Test123').valid?).to be_falsy
      end
    end
  end
end
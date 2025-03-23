# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

RSpec.describe 'POST /components' do
  def app
    Modusynth::Controllers::Components
  end

  let!(:account) { create(:random_admin) }
  let!(:session) { create(:session, account:) }
  let!(:tool) { build(:VCA) }

  describe 'Nominal case' do
    before do
      post '/', { auth_token: session.token, component_name: 'TestComponent' }
    end
    it 'Returns a 201 (Created) status code' do
      binding.pry
      expect(last_response.status).to be 201
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        component_name: 'TestComponent',
        variables: []
      )
    end
    describe 'The created component' do
      let!(:component) { Modusynth::Models::Component.first }

      it 'Has the correct name' do
        expect(component.component_name).to eq 'TestComponent'
      end
      it 'Has no variables' do
        expect(component.variables.size).to be 0
      end
    end
  end

  describe 'Alternative cases' do
  end

  describe 'Error cases' do
  end
end

# rubocop:enable Metrics/BlockLength

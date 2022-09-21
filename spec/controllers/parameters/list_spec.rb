RSpec.describe Modusynth::Controllers::Parameters do
  def app
    Modusynth::Controllers::Parameters
  end

  describe 'GET /' do
    describe 'Empty list' do
      before { get '/' }

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(parameters: [])
      end
    end
    describe 'List with items' do
      let!(:param) { create(:frequency) }

      before { get '/' }

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          'parameters' => [
            {
              'id': Modusynth::Models::Tools::Descriptor.first.id.to_s,
              'name' => 'frequency',
              'value' => 440,
              'constraints' => {
                'minimum' => 20,
                'maximum' => 2020,
                'step' => 1.0,
                'precision' => 0,
              }
            }
          ]
        })
      end
    end
  end
end
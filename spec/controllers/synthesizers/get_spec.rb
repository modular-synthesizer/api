RSpec.describe Modusynth::Controllers::Synthesizers do
  def app
    Modusynth::Controllers::Synthesizers
  end
  describe 'GET /:id' do
    describe 'Nominal case' do
      let!(:synthesizer) { create(:synthesizer) }
      before do
        get "/#{synthesizer.id.to_s}"
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: synthesizer.id.to_s,
          name: synthesizer.name,
          x: 0,
          y: 0,
          scale: 1.0,
          racks: 1,
          slots: 50
        )
      end
    end
    describe 'Error cases' do
      describe 'The synthesizer does not exist' do
        before do
          get '/unknown'
        end
        it 'Returns a 404 (Not Found) status code' do
          expect(last_response.status).to be 404
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'id', message: 'unknown'
          )
        end
      end
    end
  end
end
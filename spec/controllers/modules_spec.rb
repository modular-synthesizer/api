describe Modusynth::Controllers::Modules do
  def app
    Modusynth::Controllers::Modules
  end
  describe 'POST /' do
    let!(:synth) { create(:synthesizer) }
    let!(:tool) { create(:VCA) }

    describe 'Nominal case' do
      before do
        payload = {
          synthesizer_id: synth.id.to_s,
          tool_id: tool.id.to_s
        }
        post '/', payload.to_json
      end

      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: Modusynth::Models::Module.first.id.to_s,
          synthesizer_id: synth.id.to_s
        )
      end
    end
    describe 'Error case' do
      describe 'The synthesizer does not exist' do
        before { post '/', {synthesizer_id: 'unknown'}.to_json }

        it 'Returns a 404 (Not Found) status code' do
          expect(last_response.status).to be 404
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'synthesizer_id', message: 'unknown'
          )
        end
      end
    end
  end
end
describe Modusynth::Controllers::Modules do
  def app
    Modusynth::Controllers::Modules
  end

  let!(:account) { create(:account) }
  let!(:session) { create(:session, account: account) }

  describe 'POST /' do
    let!(:synth) { create(:synthesizer) }
    let!(:tool) { create(:VCA) }

    describe 'Nominal case' do
      before do
        payload = {
          synthesizer_id: synth.id.to_s,
          tool_id: tool.id.to_s,
          auth_token: session.token
        }
        post '/', payload.to_json
      end

      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          id: have_attributes(size: 24),
          type: 'VCA',
          innerNodes: [
            {name: 'gain', generator: 'GainNode'}
          ],
          innerLinks: [],
          parameters: [
            {
              name: 'gain',
              value: 1,
              targets: ['gain'],
              constraints: {
                minimum: 0,
                maximum: 10,
                step: 0.05,
                precision: 2
              },
              input: {
                id: have_attributes(size: 24)
              }
            }
          ],
          inputs: [
            {name: 'INPUT', target: 'gain', index: 0}
          ],
          outputs: [
            {name: 'OUTPUT', target: 'gain', index: 0}
          ]
        })
      end

      describe 'The created module' do
        let(:creation) { Modusynth::Models::Module.first }
        it 'Has the correct synthesizer' do
          expect(creation.synthesizer_id.to_s).to eq synth.id.to_s
        end
        it 'Has the correct tool' do
          expect(creation.tool_id.to_s).to eq tool.id.to_s
        end
        it 'Has parameters corresponding to the number of parameters' do
          expect(creation.parameters.size).to be 1
        end
        it 'Has the correct name for the gain parameter value' do
          expect(creation.parameters.first.name).to eq 'gain'
        end
        it 'Has the correct value for the gain parameter value' do
          expect(creation.parameters.first.value).to eq 1.0
        end
      end
    end
    describe 'Error case' do
      describe 'The synthesizer does not exist' do
        before { post '/', {synthesizer_id: 'unknown', auth_token: session.token}.to_json }

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

  include_examples 'authentication', 'post', '/'
  end
end
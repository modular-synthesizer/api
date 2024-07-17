describe Modusynth::Controllers::Modules do
  def app
    Modusynth::Controllers::Modules
  end

  let!(:account) { create(:random_admin) }
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
          category: 'tools',
          type: 'VCA',
          nodes: [
            {name: 'gain', generator: 'GainNode'}
          ],
          links: [],
          parameters: [
            {
              name: 'gainparam',
              field: 'gain',
              value: 50,
              targets: ['gain'],
              minimum: 0,
              maximum: 100,
              step: 1,
              precision: 0
            }
          ],
          ports: [
            {name: 'INPUT', target: 'gain', index: 0},
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
          expect(creation.parameters.first.name).to eq 'gainparam'
        end
        it 'Has the correct value for the gain parameter value' do
          expect(creation.parameters.first.value).to eq 50.0
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
  end
  
  include_examples 'authentication', 'post', '/'
  include_examples 'scopes', 'post', '/'
end
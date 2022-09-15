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
          synthesizer_id: synth.id.to_s,
          name: 'VCA',
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
              }
            }
          ],
          inputs: [
            {name: 'INPUT', targets: ['gain'], index: 0}
          ],
          outputs: [
            {name: 'OUTPUT', targets: ['gain'], index: 0}
          ]
        )
      end

      describe 'The created module' do
        let(:creation) { Modusynth::Models::Module.first }
        it 'Has the correct synthesizer' do
          expect(creation.synthesizer_id.to_s).to eq synth.id.to_s
        end
        it 'Has the correct tool' do
          expect(creation.tool_id.to_s).to eq tool.id.to_s
        end
        it 'Has values corresponding to the number of parameters' do
          expect(creation.values.size).to be 1
        end
        it 'Has the correct name for the gain parameter value' do
          expect(creation.values.first.name).to eq 'gain'
        end
        it 'Has the correct value for the gain parameter value' do
          expect(creation.values.first.value).to eq 1.0
        end
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
  describe 'PUT /:id' do
    let(:node) { create(:VCA_module) }

    describe 'Nominal case' do
      before do
        put "/#{node.id.to_s}", {gain: 2}.to_json
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do

      end
      it 'Has update the gain value' do
        updated = Modusynth::Models::Module.where(id: node.id.to_s).first
        value = updated.values.where(name: 'gain').first
        expect(value.value).to be 2.0
      end
    end
    describe 'Error cases' do
      describe 'When the value does not exist' do
        before { put "/#{node.id.to_s}", {unknown: 2}.to_json }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'unknown', message: 'unknown'
          )
        end
      end
      describe 'When the value is below the minimum' do
        before { put "/#{node.id.to_s}", {gain: -1}.to_json }

        it 'Returns a 404 (Not Found) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'gain', message: 'value'
          )
        end
      end
      describe 'When the value is above the maximum' do
        before { put "/#{node.id.to_s}", {gain: 11}.to_json }

        it 'Returns a 404 (Not Found) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'gain', message: 'value'
          )
        end
      end
    end
  end
  describe 'DELETE /:id' do
    let(:node) { create(:VCA_module) }

    describe 'Nominal case' do
      before { delete "/#{node.id.to_s}" }
      
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(message: 'deleted')
      end
      it 'Has deleted the module' do
        expect(Modusynth::Models::Module.all.size).to be 0
      end
    end
    describe 'Alternative cases' do
      describe 'Two consecutive calls' do
        before do
          delete "/#{node.id.to_s}"
          delete "/#{node.id.to_s}"
        end

        it 'Returns a 200 (OK) status code' do
          expect(last_response.status).to be 200
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(message: 'deleted')
        end
      end
    end
  end
end
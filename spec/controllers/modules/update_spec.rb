describe Modusynth::Controllers::Modules do
  def app
    Modusynth::Controllers::Modules
  end
  describe 'PUT /:id' do
    let!(:node) { create(:VCA_module) }
    let!(:param_id) { node.parameters.first.id.to_s }

    describe 'Nominal case' do
      before do
        payload = {parameters: [{value: 2, id: param_id}]}
        put "/#{node.id.to_s}", payload.to_json
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Has update the gain value' do
        updated = Modusynth::Models::Module.where(id: node.id.to_s).first
        value = updated.parameters.called('gain').first
        expect(value.value).to be 2.0
      end
    end
    describe 'Error cases' do
      describe 'When the value is below the minimum' do
        before do
          payload = { parameters: [{value: -1, id: param_id}] }
          put "/#{node.id.to_s}", payload.to_json
        end

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
        before do
          payload = { parameters: [{value: 11, id: param_id}] }
          put "/#{node.id.to_s}", payload.to_json
        end

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
end
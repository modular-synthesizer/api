describe Modusynth::Controllers::Modules do
  def app
    Modusynth::Controllers::Modules
  end

  let!(:account) { create(:account) }
  let!(:session) { create(:session, account: account) }

  describe 'PUT /:id' do
    let!(:synth) { create(:synthesizer, account: account) }
    let!(:node) { create(:VCA_module, synthesizer: synth) }
    let!(:param_id) { node.parameters.first.id.to_s }

    describe 'Nominal case' do
      before do
        payload = {
          parameters: [{value: 2, id: param_id}],
          auth_token: session.token
        }
        put "/#{node.id.to_s}", payload.to_json
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Has update the gain value' do
        node.reload
        expect(node.parameters.first.value).to be 2.0
      end
    end
    describe 'Error cases' do
      describe 'When the value is below the minimum' do
        before do
          payload = {
            parameters: [{value: -1, id: param_id}],
            auth_token: session.token
          }
          put "/#{node.id.to_s}", payload.to_json
        end

        it 'Returns a 404 (Not Found) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'gainparam', message: 'value'
          )
        end
      end
      describe 'When the value is above the maximum' do
        before do
          payload = {
            parameters: [{value: 101, id: param_id}],
            auth_token: session.token
          }
          put "/#{node.id.to_s}", payload.to_json
        end

        it 'Returns a 404 (Not Found) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'gainparam', message: 'value'
          )
        end
      end
    end

    include_examples 'authentication', 'put', '/:id'

    include_examples 'ownership', 'put', '/:id', :VCA_module
  end
end
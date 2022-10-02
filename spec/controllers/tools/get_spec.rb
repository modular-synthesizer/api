RSpec.describe Modusynth::Controllers::Tools do
  def app
    Modusynth::Controllers::Tools
  end

  describe 'GET /:id' do
    let!(:account) { create(:account) }
    let!(:session) { create(:session, account: account) }

    describe 'Nominal case' do
      let!(:tool) { create(:VCA) }

      before do
        get "/#{tool.id.to_s}", {auth_token: session.token}
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          id: tool.id.to_s,
          name: 'VCA',
          innerNodes: [
            {name: 'gain', generator: 'GainNode'}
          ],
          parameters: [
            {
              name: 'gain',
              value: 1,
              constraints: {
                minimum: 0,
                maximum: 10,
                step: 0.05,
                precision: 2
              },
              targets: ['gain']
            }
          ],
          innerLinks: [],
          inputs: [
            {name: 'INPUT', index: 0, target: 'gain'}
          ],
          outputs: [
            {name: 'OUTPUT', index: 0, target: 'gain'}
          ]
        })
      end
    end
    describe 'Error cases' do
      describe 'When the UUID is not found' do
        before do
          get '/unknown', {auth_token: session.token}
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

    include_examples 'authentication', 'get', '/anything'
  end
end
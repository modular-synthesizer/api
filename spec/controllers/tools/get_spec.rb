RSpec.describe Modusynth::Controllers::Tools do
  def app
    Modusynth::Controllers::Tools
  end

  describe 'GET /:id' do
    let!(:account) { create(:random_admin) }
    let!(:session) { create(:session, account: account) }

    describe 'Nominal case' do
      let!(:dopefun) { create(:dopefun) }
      let!(:tool) { create(:VCA, category: dopefun) }

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
          nodes: [
            {name: 'gain', generator: 'GainNode'}
          ],
          parameters: [
            {
              name: 'gainparam',
              field: 'gain',
              default: 50.0,
              minimum: 0,
              maximum: 100,
              step: 1,
              precision: 0,
              targets: ['gain']
            }
          ],
          links: [],
          ports: [
            {name: 'INPUT', index: 0, target: 'gain'},
            {name: 'OUTPUT', index: 0, target: 'gain'}
          ],
          controls: [
            {component: 'Knob', payload: {x: 0, y: 100, target: 'gainparam'}}
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
  end

  include_examples 'authentication', 'get', '/anything'
  include_examples 'scopes', 'get', '/anything'
end
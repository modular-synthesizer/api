RSpec.describe Modusynth::Controllers::Tools do
  def app
    Modusynth::Controllers::Tools
  end

  describe 'GET /' do
    let!(:account) { create(:account) }
    let!(:session) { create(:session, account: account) }

    describe 'empty list' do
      before { get '/', {auth_token: session.token} }

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'returns an empty list when nothing has been created' do
        expect(last_response.body).to include_json({})
      end
    end

    describe 'not empty list' do
      let!(:tool) { create(:VCA) }
      before { get '/', {auth_token: session.token} }
      
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(JSON.parse(last_response.body)).to eq({
          'tools' => [
            {'id' => tool.id.to_s, 'name' => 'VCA', 'slots' => 3}
          ]
        })
      end
    end

    include_examples 'authentication', 'get', '/'
  end
end
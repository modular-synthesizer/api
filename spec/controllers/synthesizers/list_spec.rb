RSpec.describe Modusynth::Controllers::Synthesizers do
  def app
    Modusynth::Controllers::Synthesizers
  end

  let!(:babausse) { create(:babausse) }
  let!(:session) { create(:session, account: babausse) }

  describe 'GET /' do
    describe 'empty list' do
      before do
        get '/', {auth_token: session.token}
      end

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns an empty list' do
        expect(JSON.parse(last_response.body)).to eq([])
      end
    end
    describe 'populated list' do
      let!(:synthesizer) {
        Modusynth::Services::Synthesizers.instance.create(name: 'test synth', account: session.account)
      }
      before do
        get '/', {auth_token: session.token}
      end

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json([
          {
            id: a_kind_of(String),
            members: [
              {
                id: synthesizer.creator.id.to_s,
                username: babausse.username,
                account_id: babausse.id.to_s,
                type: 'creator'
              }
            ],
            name: 'test synth',
            x: 0,
            y: 0,
            scale: 1
          }
        ])
      end
    end
  end

  include_examples 'authentication', 'get', '/'
end
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
        expect(JSON.parse(last_response.body)).to eq({'synthesizers' => []})
      end
    end
    describe 'populated list' do
      let!(:synthesizer) {
        Modusynth::Services::Synthesizers.instance.create(
          {'name' => 'test synth'},
          session.account
        )
      }
      before do
        get '/', {auth_token: session.token}
      end

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          synthesizers: [
            {
              id: a_kind_of(String),
              name: 'test synth'
            }
          ]
        )
      end
    end
  end

  include_examples 'authentication', 'post', '/'
end
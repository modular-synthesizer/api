RSpec.describe 'GET /processors/:id' do
  def app
    Modusynth::Controllers::AudioProcessors
  end

  let!(:account) { create(:account, admin: true) }
  let!(:session) { create(:session, account:) }
  let!(:processor) { create(:audio_processor, account:) }
  describe 'Nominal case' do
    before do
      get "/#{processor.id.to_s}", { auth_token: session.token }
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Has the correct body' do
      expect(last_response.body).to include_json(
        url: 'https://www.example.com/processor.js'
      )
    end
  end
  describe 'Error cases' do
    describe 'UUID not found' do
      before do
        get '/unknown', { auth_token: session.token }
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
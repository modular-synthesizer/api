RSpec.describe 'GET /processors' do
  def app
    ::Modusynth::Controllers::AudioProcessors
  end

  let!(:account) { create(:account, admin: true) }
  let!(:session) { create(:session, account:) }

  describe 'Nominal case' do
    let!(:processor) { create(:audio_processor, registration_name: 'testname', account:) }
    let!(:public_processor) { create(:audio_processor, registration_name: 'public', public: true, account:) }

    describe 'From the owner point of view' do
      before do
        get '/', { auth_token: session.token }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct count of processors' do
        expect(JSON.parse(last_response.body).count).to be 2
      end
    end
    describe 'From another point of view' do
      let!(:guest) { create(:account) }
      let!(:guest_session) { create(:session, account: guest) }

      before do
        get '/', { auth_token: guest_session.token }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct count of processors' do
        expect(JSON.parse(last_response.body).count).to be 1
      end
      it 'Returns the correct processor' do
        expect(JSON.parse(last_response.body).first['id']).to eq public_processor.id.to_s
      end
    end
  end
  describe 'Empty list' do
    before do
      get '/', { auth_token: session.token }
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expect(last_response.body).to eq '[]'
    end
  end
end
RSpec.describe 'DELETE /:id' do

  def app
    Modusynth::Controllers::AudioProcessors
  end

  let!(:account) { create(:account, admin: true) }
  let!(:session) { create(:session, account:) }
  let!(:processor) { create(:audio_processor, account:) }

  describe 'Nominal case' do
    before do
      delete "/#{processor.id.to_s}", { auth_token: session.token }
    end
    it 'Returns a 204 (No Content) status code' do
      expect(last_response.status).to be 204
    end
    it 'Has destroyed the record' do
      expect(Modusynth::Models::AudioProcessor.all.count).to be 0
    end
  end
  describe 'Alternative case' do
    describe 'When the record is not found' do
      before do
        delete 'unknown', { auth_token: session.token }
      end
      it 'Returns a 204 (No Content) status code' do
        expect(last_response.status).to be 204
      end
      it 'Has not destroyed the record' do
        expect(Modusynth::Models::AudioProcessor.all.count).to be 1
      end
    end
  end
end
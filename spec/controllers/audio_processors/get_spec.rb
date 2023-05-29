RSpec.describe 'GET /processors/:id' do
  def app
    Modusynth::Controllers::AudioProcessors
  end

  let!(:account) { create(:account, admin: true) }
  let!(:session) { create(:session, account:) }
  let!(:processor) do
    create(:audio_processor,
      registration_name: 'fake-processor',
      process_function: 'console.log("test fake processor");',
      account:
    )
  end
  describe 'Nominal case' do
    before do
      get "/#{processor.id.to_s}", { auth_token: session.token }
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Has the correct MIME type' do
      expect(last_response.headers["Content-Type"]).to start_with 'text/javascript'
    end
    it 'Returns the correct body' do
      expectation = <<-EXPECTED
class FakeProcessor extends AudioWorkletProcessor {
  process(inputs, outputs, parameters) {
    console.log("test fake processor");
    return true;
  }
}

registerProcessor("fake-processor", FakeProcessor);
EXPECTED

      expect(last_response.body).to eq expectation
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
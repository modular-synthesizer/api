RSpec.describe 'POST /processors' do

  def app
    ::Modusynth::Controllers::AudioProcessors
  end

  let!(:account) { create(:account, admin: true) }
  let!(:session) { create(:session, account:) }

  describe 'Nominal case' do
    before do
      post '/', {
        auth_token: session.token,
        registration_name: 'test-name',
        process_function: 'return true;'
      }
    end
    it 'Returns a 201 (Created) status code' do
      expect(last_response.status).to be 201
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        registration_name: 'test-name',
        process_function: 'return true;'
      )
    end
    describe 'Created processor' do
      let!(:creation) { Modusynth::Models::AudioProcessor.first }

      it 'Has created a processor with the correct account' do
        expect(creation.account.id.to_s).to eq account.id.to_s
      end
      it 'Has the correct name' do
        expect(creation.registration_name).to eq 'test-name'
      end
      it 'Has the correct function' do
        expect(creation.process_function).to eq 'return true;'
      end
    end
  end
  describe 'Error cases' do
    describe 'Registration name not given' do
      before do
        post '/', {
          auth_token: session.token,
          process_function: 'return true;'
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          message: 'required', key: 'registration_name'
        )
      end
    end
    describe 'Registration name not uniq' do
      let!(:processor) { create(:audio_processor, account: account, registration_name: 'test-name') }
      before do
        post '/', {
          auth_token: session.token,
          registration_name: 'test-name',
          process_function: 'return true;'
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          message: 'uniq', key: 'registration_name'
        )
      end
    end
    describe 'Registration name in a wrong format' do
      before do
        post '/', {
          auth_token: session.token,
          registration_name: 'test_name',
          process_function: 'return true;'
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          message: 'format', key: 'registration_name'
        )
      end
    end
    describe 'processing function not given' do
      before do
        post '/', {
          auth_token: session.token,
          registration_name: 'test-name',
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          message: 'required', key: 'process_function'
        )
      end
    end
  end
  
  include_examples 'admin', 'post', '/'
end
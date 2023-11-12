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
        url: 'https://www.example.com/processor.js'
      }
    end
    it 'Returns a 201 (Created) status code' do
      expect(last_response.status).to be 201
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        url: 'https://www.example.com/processor.js',
        public: false
      )
    end
    describe 'Created processor' do
      let!(:creation) { Modusynth::Models::AudioProcessor.first }

      it 'Has created a processor with the correct account' do
        expect(creation.account.id.to_s).to eq account.id.to_s
      end
      it 'Has created a processor with the correct url' do
        expect(creation.url).to eq 'https://www.example.com/processor.js'
      end
    end
  end
  describe 'Error cases' do
    describe 'URL name not given' do
      before do
        post '/', {
          auth_token: session.token,
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          message: 'required', key: 'url'
        )
      end
    end
    describe 'URL name in a wrong format' do
      before do
        post '/', {
          auth_token: session.token,
          url: 'test'
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          message: 'format', key: 'url'
        )
      end
    end
  end
  
  include_examples 'admin', 'post', '/'
end
RSpec.describe 'POST /sessions' do
  def app
    Modusynth::Controllers::Sessions
  end

  let!(:babausse) { create(:babausse) }
  let!(:date_matcher) { match(/\A[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\+[0-9]{2}:[0-9]{2}\Z/) }

  describe 'Nominal case' do
    before do
      payload = {
        account_id: babausse.id.to_s,
        duration: 3600
      }
      post '/', payload.to_json
    end
    it 'Returns a 201 (Created) status code' do
      expect(last_response.status).to be 201
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        token: have_attributes(size: 24),
        duration: 3600,
        created_at: date_matcher
      )
    end
    describe 'The created session' do
      let!(:session) { Modusynth::Models::Session.first }
      it 'Has the correct account' do
        expect(session.account.id.to_s).to eq babausse.id.to_s
      end
      it 'Has a token correctly initialized' do
        expect(session.token).to have_attributes(size: 24)
      end
      it 'Has the correct duration' do
        expect(session.duration).to be 3600
      end
    end
  end
  describe 'Alternative cases' do
    before do
      post '/', {account_id: babausse.id.to_s}.to_json
    end
    describe 'When a duration is not given' do
      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          token: have_attributes(size: 24),
          duration: 3600 * 24 * 7,
          created_at: date_matcher
        )
      end
      describe 'The created session' do
        let!(:session) { Modusynth::Models::Session.first }

        it 'Has a duration set to the default' do
          expect(session.duration).to be 3600 * 24 * 7
        end
      end
    end
  end
  describe 'Error cases' do
    describe 'When the account_id is not given' do
      before do 
        post '/', {duration: 3600}.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'account_id', message: 'required'
        )
      end
    end
    describe 'When the account is not found' do
      before do
        post '/', {duration: 3600, account_id: 'unknown'}.to_json
      end
      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'account_id', message: 'unknown'
        )
      end
    end
  end
end
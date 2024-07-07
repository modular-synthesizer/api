RSpec.describe 'PUT /accounts/:id' do
  def app
    Modusynth::Controllers::Accounts
  end

  let!(:account) { create(:babausse) }
  let!(:session) { create(:session, account:) }

  describe 'Nominal case' do
    describe 'A user updates their own account' do
      before do
        put '/own', {
          auth_token: session.token,
          sample_rate: 192000
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: account.id.to_s,
          username: account.username,
          sample_rate: 192000
        )
      end
      it 'Has updated the sample rate correctly' do
        account.reload
        expect(account.sample_rate).to be 192000
      end
    end
  end

  describe 'Error cases' do
    describe 'The sample rate is too low' do
      before do
        put '/own', {
          auth_token: session.token,
          sample_rate: 44099
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'sample_rate', message: 'value'
        )
      end
      it 'Has not updated the sample rate' do
        account.reload
        expect(account.sample_rate).to be 44100
      end
    end
    describe 'The sample rate is too high' do
      before do
        put '/own', {
          auth_token: session.token,
          sample_rate: 192001
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'sample_rate', message: 'value'
        )
      end
      it 'Has not updated the sample rate' do
        account.reload
        expect(account.sample_rate).to be 44100
      end
    end
    describe 'The requester does not own the account and is not admin' do
      let!(:intruder) { create(:account) }
      let!(:session) { create(:session, account: intruder) }

      before do
        put '/own', {
          auth_token: session.token,
          sample_rate: 96000
        }
      end
      it 'Returns a 403 (Forbidden) status code' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'auth_token', message: 'forbidden'
        )
      end
      it 'Has not updated the sample rate' do
        account.reload
        expect(account.sample_rate).to be 44100
      end
    end
  end
end
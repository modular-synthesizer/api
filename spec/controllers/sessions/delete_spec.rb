RSpec.describe 'DELETE /:id' do

  def app
    Modusynth::Controllers::Sessions
  end

  let!(:babausse) { create(:babausse) }
  let!(:session) { create(:session, account: babausse) }
  let!(:auth_session) { create(:session, account: babausse) }

  describe 'Nominal case' do
    before do
      delete "/#{session.token}", {auth_token: session.token}
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        token: session.token,
        expired: true
      )
    end
    describe 'Invalidated session' do
      let!(:result) { Modusynth::Models::Session.where(token: session.token).first }

      it 'Is considered logged out' do
        expect(result.logged_out).to be_truthy
      end
      it 'Is considered expired' do
        expect(result.expired?).to be_truthy
      end
    end
  end
  describe 'Alternative cases' do
    before do
      delete "/#{session.token}", {auth_token: auth_session.token}
    end

    describe 'The session token is from another session of the same user' do
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          token: session.token,
          expired: true
        )
      end
      describe 'Both sessions' do
        let!(:result) { Modusynth::Models::Session.where(token: session.token).first }
        let!(:auth_result) { Modusynth::Models::Session.where(token: auth_session.token).first }

        it 'Has not invalidated the authentication session' do
          expect(auth_result.logged_out).to be_falsy
        end
        it 'Does not consider the authentication session as expired' do
          expect(auth_result.expired?).to be_falsy
        end
        it 'has invalidated the session' do
          expect(result.logged_out).to be_truthy
        end
        it 'Considers the session as invalid' do
          expect(result.expired?).to be_truthy
        end
      end
    end
  end
  describe 'Error cases' do
    describe 'The authentication token is not given to identify the user' do
      before do
        delete "/#{session.token}"
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'auth_token', message: 'required'
        )
      end
    end
    describe 'The authentication token is not found' do
      before do
        delete "/#{session.token}", { auth_token: 'unknown' }
      end
      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'auth_token', message: 'unknown'
        )
      end
    end
    describe 'The session token is not found' do
      before do
        delete '/unknown', { auth_token: auth_session.token }
      end
      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'token', message: 'unknown'
        )
      end
    end
    describe 'The authentication token is attached to another user' do
      let!(:cidualia) { create(:cidualia) }
      let!(:cid_session) { create(:session, account: cidualia) }

      before do
        delete "/#{session.token}", { auth_token: cid_session.token }
      end
      it 'Returns a 403 (Forbidden) status code' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'auth_token', message: 'forbidden'
        )
      end
    end
    describe 'The authentication token is marked as expired' do
      before do
        delete "/#{auth_session.token}", { auth_token: auth_session.token }
        delete "/#{session.token}", { auth_token: auth_session.token }
      end
      it 'Returns a 403 (Forbidden) status code' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'auth_token', message: 'forbidden'
        )
      end
    end
  end
end
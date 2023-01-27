RSpec.describe 'DELETE /:id' do

  def app
    Modusynth::Controllers::Sessions
  end

  let!(:babausse) { create(:babausse) }
  let!(:session) { create(:session, account: babausse, token: '6330b8cab8c724a019c7b839') }
  let!(:auth_session) { create(:session, account: babausse) }

  describe 'Nominal case' do
    before do
      delete "/#{session.token}", {auth_token: session.token}
    end
    it 'Returns a 204 (No Content) status code' do
      expect(last_response.status).to be 204
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
      it 'Returns a 204 (No Content) status code' do
        expect(last_response.status).to be 204
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

    describe 'The session token is not found' do
      before do
        delete '/unknown', { auth_token: auth_session.token }
      end
      it 'Returns a 204 (No Content) status code' do
        expect(last_response.status).to be 204
      end
    end
  end

  include_examples 'authentication', 'delete', '/anything'
end
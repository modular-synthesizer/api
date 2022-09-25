RSpec.describe 'POST /accounts' do
  def app
    Modusynth::Controllers::Accounts
  end
  describe 'Nominal case' do
    before do
      payload = {
        username: 'babausse',
        password: 'testpassword',
        password_confirmation: 'testpassword',
        email: 'courtois.vincent@outlook.com'
      }
      post '/', payload.to_json
    end
    it 'Returns a 201 (Created) status code' do
      expect(last_response.status).to be 201
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        username: 'babausse',
        email: 'courtois.vincent@outlook.com'
      )
    end
    describe 'The created account' do
      let!(:account) { Modusynth::Models::Account.first }

      it 'Has the correct username' do
        expect(account.username).to eq 'babausse'
      end
      it 'Has the correct email' do
        expect(account.email).to eq 'courtois.vincent@outlook.com'
      end
      it 'Has the correct password' do
        expect(account.authenticate('testpassword')).to be_truthy
      end
    end
  end
  describe 'Error cases' do
    describe 'The name is not given' do
      before do
        payload = {
          email: 'courtois.vincent@outlook.com',
          password: 'testpassword',
          password_confirmation: 'testpassword'
        }
        post '/', payload.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'username', message: 'required'
        )
      end
    end
    describe 'The name is too short' do
      before do
        payload = {
          username: 'foo',
          email: 'courtois.vincent@outlook.com',
          password: 'testpassword',
          password_confirmation: 'testpassword'
        }
        post '/', payload.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'username', message: 'length'
        )
      end
    end
    describe 'The name is already used' do
      before do
        create(:babausse)
        payload = {
          username: 'babausse',
          email: 'vincent.courtois@coddity.com',
          password: 'testpassword',
          password_confirmation: 'testpassword'
        }
        post '/', payload.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'username', message: 'uniq'
        )
      end
    end
    describe 'The email is not given' do
      before do
        payload = {
          username: 'babausse',
          password: 'testpassword',
          password_confirmation: 'testpassword'
        }
        post '/', payload.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'email', message: 'required'
        )
      end
    end
    describe 'The email has a bad format' do
      before do
        payload = {
          username: 'babausse',
          email: 'test_bad_format',
          password: 'testpassword',
          password_confirmation: 'testpassword'
        }
        post '/', payload.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'email', message: 'format'
        )
      end
    end
    describe 'The email is already used' do
      before do
        create(:babausse)
        payload = {
          username: 'babaussine',
          email: 'courtois.vincent@outlook.com',
          password: 'testpassword',
          password_confirmation: 'testpassword'
        }
        post '/', payload.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'email', message: 'uniq'
        )
      end
    end
    describe 'The password is not given' do
      before do
        payload = {
          username: 'babausse',
          email: 'courtois.vincent@outlook.com',
          password_confirmation: 'testpassword'
        }
        post '/', payload.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'password', message: 'required'
        )
      end
    end
    describe 'The password confirmation is not given' do
      before do
        payload = {
          username: 'babausse',
          email: 'courtois.vincent@outlook.com',
          password: 'testpassword'
        }
        post '/', payload.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'password_confirmation', message: 'required'
        )
      end
    end
    describe 'The password does not match its confirmation' do
      before do
        payload = {
          username: 'babausse',
          email: 'courtois.vincent@outlook.com',
          password: 'testpassword',
          password_confirmation: 'wrongconfirmation'
        }
        post '/', payload.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'password_confirmation', message: 'confirmation'
        )
      end
    end
  end
end
# rubocop:disable Metrics/BlockLength
RSpec.describe 'POST /tokens' do
  def app
    Modusynth::Controllers::Tokens.new
  end

  let!(:account) { create(:babausse, jwt_secret: 'this_account_secret') }
  let!(:now) { Time.at(0) }
  let!(:expected_token) do
    %w[
      eyJhbGciOiJIUzI1NiJ9
      eyJzdWIiOiJiYWJhdXNzZSIsImp0aSI6InJhbmRvbV9oZXhfc3RyaW5nIiwiZXhwIjo2MDAsImlzcyI6IlN5bnBsZSJ9
      c0u4yrv2cuGSTzK6Z9wS3NwrOT3zyJpiFbqWgkrpmSg
    ].join('.')
  end

  before :each do
    allow(SecureRandom).to receive(:hex).and_return('random_hex_string')
    allow(Time).to receive(:now).and_return(now)
  end

  describe 'Nominal case' do
    before do
      post '/', { username: 'babausse', password: account.password }.to_json
    end
    it 'Returns a 201 (Created) status code' do
      expect(last_response.status).to be 201
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        refresh_token: 'random_hex_string',
        jwt_token: expected_token
      )
    end
    it 'Has created only one token' do
      expect(Modusynth::Models::Token.all.count).to be 1
    end
    describe 'The created token' do
      let!(:token) { Modusynth::Models::Token.all.first }

      it 'Has the correct JWT token' do
        expect(token.jwt_token_id).to eq 'random_hex_string'
      end
      it 'Has the correct date of refreshment' do
        expect(token.refreshed_at).to be nil
      end
      it 'Has the correct date of invalidation' do
        expect(token.invalidated_at).to be nil
      end
      it 'Has the correct refresh token' do
        expect(token.refresh_token).to eq 'random_hex_string'
      end
    end
  end
  describe 'Exception cases' do
    describe 'When the username is not found' do
      before do
        post '/', { username: 'unknown', password: account.password }.to_json
      end
      it 'Returns a 403 (Forbidden) status code' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(key: 'username', message: 'forbidden')
      end
      it 'Has not created a token' do
        expect(Modusynth::Models::Token.all.count).to be 0
      end
    end
    describe 'When the password does not match the username' do
      before do
        post '/', { username: 'babausse', password: 'invalid_password' }.to_json
      end
      it 'Returns a 403 (Forbidden) status code' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(key: 'username', message: 'forbidden')
      end
      it 'Has not created a token' do
        expect(Modusynth::Models::Token.all.count).to be 0
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength

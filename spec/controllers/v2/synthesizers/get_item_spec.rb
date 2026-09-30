# rubocop:disable Metrics/BlockLength
# frozen_string_literal: true

RSpec.describe Modusynth::Controllers::V2::Synthesizers do
  def app
    Modusynth::Controllers::V2::Synthesizers
  end

  # Life is simpler when you're an admin as you have all rights.
  let!(:account) { create(:random_admin) }
  # The session used to authentify each and every request.
  let!(:session) { create(:session, account: account) }
  # The synthesizer under tests, with modules and cables.
  let!(:synthesizer) { create(:full_synthesizer) }
  # The link between the synthesizer and the user.
  let!(:membership) { create(:membership, synthesizer:, account:) }

  describe 'Nominal case' do
    before do
      get "/#{synthesizer.id}", { auth_token: session.token }
    end
    it 'gets a synthesizer when asked with a correct UUID' do
      expect(last_response.status).to be 200
      expect(JSON.parse(last_response.body)).to eq({})
    end
  end
  describe 'Error cases' do
    it 'throws an error when the synthesizer identified by this UUID does not exist' do
      get '/unknown', { auth_token: session.token }
      expect(last_response.status).to be 404
      expect(last_response.body).to include_json({ key: 'id', message: 'unknown' })
    end
    it 'throws an error when the synthesizer does not belong to this user' do
      attacker_session = create(:session, account: create(:random_admin))
      get "/#{synthesizer.id}", { auth_token: attacker_session.token }
      expect(last_response.status).to be 404
      expect(last_response.body).to include_json({ key: 'id', message: 'unknown' })
    end
    it 'throws an error when the user does not have the right to access this resource' do
      attacker_session = create(:session, account: create(:account_without_rights))
      get "/#{synthesizer.id}", { auth_token: attacker_session.token }
      expect(last_response.status).to be 403
      expect(last_response.body).to include_json({ key: 'auth_token', message: 'forbidden' })
    end
  end
end

# rubocop:enable Metrics/BlockLength

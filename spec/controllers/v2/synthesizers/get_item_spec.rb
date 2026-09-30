# frozen_string_literal: true

RSpec.describe Modusynth::Controllers::V2::Synthesizers do
  def app
    Modusynth::Controllers::V2::Synthesizers
  end

  # Life is simpler when you're an admin as you have all rights.
  let!(:account) { create(:random_admin) }
  # The session used to authentify each and every request.
  let!(:session) { create(:session, account: account) }

  describe 'Nominal case' do
    before do
      get '/test_uuid', { auth_token: session.token }
    end
    it 'gets a synthesizer when asked with a correct UUID' do
      expect(last_response.status).to be 200
      expect(JSON.parse(last_response.body)).to eq({})
    end
  end
end

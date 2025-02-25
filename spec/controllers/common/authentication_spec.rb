# rubocop:disable Metrics/BlockLength
# frozen_string_literal: true

class TestController < Modusynth::Controllers::Base
  api_route 'get', '/' do
    halt 204
  end
end

RSpec.describe Modusynth::Controllers::Base do
  def app
    TestController
  end

  let!(:account) { create(:babausse) }

  describe 'Valid session' do
    let!(:session) {
      s = Modusynth::Models::Session.new(account:)
      s.created_at = DateTime.now - 29
      s.last_activity_date = DateTime.now
      s.save!
      s
    }
    it 'Returns the status code of the route when called' do
      get '/', { auth_token: session.token }
      expect(last_response.status).to be 204
    end
  end
  describe 'When a session has been deleted by the user' do
    let!(:session) {
      s = Modusynth::Models::Session.new(account:)
      s.logged_out = true
      s.save!
      s
    }
    it 'Returns a 403 (Forbidden) status code' do
      get '/', { auth_token: session.token }
      expect(last_response.status).to be 403
    end
  end
  describe 'When a session was created more than 30 days prior' do
    let!(:session) {
      s = Modusynth::Models::Session.new(account:)
      s.created_at = DateTime.now - 31
      s.save!
      s
    }
    it 'Returns a 403 (Forbidden) status code' do
      get '/', { auth_token: session.token }
      expect(last_response.status).to be 403
    end
  end
  describe 'When the last activity of a session was more than 15 days ago' do
    let!(:session) {
      s = Modusynth::Models::Session.new(account:)
      s.last_activity_date = DateTime.now - 16
      s.save!
      s
    }
    it 'Returns a 403 (Forbidden) status code' do
      get '/', { auth_token: session.token }
      expect(last_response.status).to be 403
    end
  end
  describe 'Update the last activity date when making a request' do
    let!(:session) {
      s = Modusynth::Models::Session.new(account:)
      s.last_activity_date = DateTime.now - 2
      s.save!
      s
    }
    it 'Has correctly updated the last activity date' do
      get '/', { auth_token: session.token }
      updated = Modusynth::Models::Session.find_by(token: session.token)
      expect(updated.last_activity_date > (DateTime.now - 1)).to be true
    end
  end
end
# rubocop:enable Metrics/BlockLength

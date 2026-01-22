# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe 'GET /categories' do
  def app
    Modusynth::Controllers::Categories
  end

  let!(:account) { create(:admin) }
  let!(:auth_token) { create_token(account) }

  describe 'Nominal case' do
    before do
      post '/admin-uuid/categories', { name: 'testCategory', auth_token: }.to_json
      get '/admin-uuid/categories', { auth_token: }
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expected = [{ id: have_attributes(size: 24), name: 'testCategory' }]
      expect(last_response.body).to include_json(expected)
    end
  end
  describe 'Alternative cases' do
    describe 'Empty list' do
      before do
        get '/admin-uuid/categories', { auth_token: }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json([])
      end
    end
  end

  include_examples 'authentication', 'GET /categories'
end

# rubocop:enable Metrics/BlockLength

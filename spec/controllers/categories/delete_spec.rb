# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe 'DELETE /categories' do
  def app
    Modusynth::Controllers::Categories
  end

  let!(:admin) { create(:admin) }
  let!(:auth_token) { create_token(admin) }

  describe 'Nominal case' do
    before do
      post '/admin-uuid/categories', { name: 'testCategory', auth_token: }.to_json
      category_id = JSON.parse(last_response.body)['id']
      delete "/admin-uuid/categories/#{category_id}", { auth_token: }
    end
    it 'returns a 204 (No Content) status code' do
      expect(last_response.status).to be 204
    end
  end
  describe 'Alternative cases' do
    describe 'When the category ID does not exist' do
      before do
        delete '/admin-uuid/categories/unknown', { auth_token: }
      end
      it 'Returns a 204 (No Content) status code' do
        expect(last_response.status).to be 204
      end
    end
  end

  include_examples 'authentication', 'DELETE /categories/category-id'
end

# rubocop:enable Metrics/BlockLength

# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe 'PUT /categories/:id' do
  def app
    Modusynth::Controllers::Categories.new
  end

  let!(:account) { create(:admin) }
  let!(:auth_token) { create_token(account) }

  let!(:dopefun) { create(:dopefun) }
  describe 'Nominal case' do
    before do
      put "/admin-uuid/categories/#{dopefun.id}", { name: 'otherName', auth_token: }.to_json
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        id: dopefun.id.to_s,
        name: 'otherName'
      )
    end
    describe 'Updated category' do
      it 'Has correctly updated its name' do
        expect(Modusynth::Models::Category.first.name).to eq 'otherName'
      end
    end
  end
  describe 'Alternative case' do
    describe 'A name is not given' do
      before do
        put "/admin-uuid/categories/#{dopefun.id}", { auth_token: }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: dopefun.id.to_s,
          name: 'dopefun'
        )
      end
      describe 'Updated category' do
        let!(:category) { Modusynth::Models::Category.first }
        it 'Has not updated the name' do
          expect(category.name).to eq 'dopefun'
        end
      end
    end
  end
  describe 'error cases' do
    describe 'The category is not found' do
      before do
        put '/admin-uuid/categories/unknown', { auth_token: }
      end
      it 'returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'id', message: 'unknown'
        )
      end
    end
    describe 'The name is too short' do
      before do
        put "/admin-uuid/categories/#{dopefun.id}", { name: 'c', auth_token: }.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'name', message: 'length'
        )
      end
    end
    describe 'The name does not have the correct format' do
      before do
        put "/admin-uuid/categories/#{dopefun.id}", { name: 'new name', auth_token: }.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'name', message: 'format'
        )
      end
    end
  end

  include_examples 'authentication', 'PUT /categories/category-id'
end
# rubocop:enable Metrics/BlockLength

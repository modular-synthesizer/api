RSpec.describe 'PUT /:id' do
  let!(:account) { create(:account, admin: true) }
  let!(:session) { create(:session, account: account) }
  let!(:scopes) { create_list(:scope, 2) }
  let!(:group) { create(:group, scopes: scopes) }
  let!(:new_scope) { create(:scope, label: 'Scopes::Test') }

  describe 'Nominal case' do
    before do
      payload = {
        slug: 'new-slug',
        scopes: [new_scope.id.to_s],
        auth_token: session.token
      }
      put "/#{group.id.to_s}", payload.to_json
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do

    end
    describe 'Attributes of the updated record' do
      it 'Has updated the slug' do

      end
      it 'Has updated the scopes' do

      end
    end
  end
  describe 'Alternative cases' do
    describe 'When no slug is provided' do
      it 'Returns a 200 (OK) status code' do

      end
      it 'Returns the correct body' do

      end
    end
    describe 'When no scopes are provided' do
      
    end
  end
  describe 'Error cases' do
    describe 'When the slug is too short' do

    end
    describe 'When the slug does not have the right format' do

    end
  end
end
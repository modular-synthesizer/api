RSpec.describe 'PUT /accounts/:id/groups' do

  def app
    Modusynth::Controllers::Accounts
  end

  let!(:default_group) { create(:group, slug: 'default', is_default: true) }
  let!(:admin) { create(:account, admin: true) }
  let!(:account) { create(:account) }

  let!(:session) { create(:session, account: admin) }
  let!(:group) { create(:group, slug: 'test-group') }

  describe 'Nominal case' do
    before do
      put "/#{account.id.to_s}/groups", {
        auth_token: session.token,
        groups: [ { id: group.id.to_s } ]
      }.to_json
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        groups: [
          {id: default_group.id.to_s, slug: 'default'},
          {id: group.id.to_s, slug: 'test-group'}
        ]
      )
    end
    describe 'The updated account' do
      before do
        account.reload
      end
      it 'Has the correct number of groups' do
        expect(account.all_groups.count).to be 2
      end
      it 'Has kept the default groups' do
        expect(account.all_groups.first.id).to eq default_group.id
      end
      it 'Has added the group to the list of groups' do
        expect(account.all_groups.last.id).to eq group.id
      end
    end
  end
  describe 'error cases' do
    describe 'The identifier off a group is unknown' do
      before do
        put "/#{account.id.to_s}/groups", {
          auth_token: session.token,
          groups: [ { id: 'unknown' } ]
        }.to_json
      end
      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'groups[0].id', message: 'unknown'
        )
      end
    end
    describe 'When the account is not an administrator' do
      let!(:unauthorized) { create(:session, account:) }

      before do
        put "/#{account.id.to_s}/groups", { auth_token: unauthorized.token }.to_json
      end
      it 'Returns a 403 (Forbidden) status code' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'auth_token', message: 'forbidden'
        )
      end
    end
  end
end
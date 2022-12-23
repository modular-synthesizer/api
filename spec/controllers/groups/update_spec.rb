RSpec.describe 'PUT /:id' do
  def app
    Modusynth::Controllers::Groups.new
  end

  let!(:account) { create(:account, admin: true) }
  let!(:session) { create(:session, account: account) }
  let!(:scopes) { [
    create(:scope, label: 'Scopes::First'),
    create(:scope, label: 'Scopes::Second')
  ] }
  let!(:group) { create(:group, scopes: scopes, slug: 'test-group') }
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
      expect(last_response.body).to include_json(
        id: group.id.to_s,
        slug: 'new-slug',
        scopes: [
          {id: new_scope.id.to_s, label: 'Scopes::Test'}
        ]
      )
    end
    describe 'Attributes of the updated record' do
      let!(:updated) { Modusynth::Models::Permissions::Group.first }
      it 'Has updated the slug' do
        expect(updated.slug).to eq 'new-slug'
      end
      it 'Has updated the scopes' do
        expect(updated.scopes.map(&:id)).to eq [new_scope.id]
      end
    end
  end
  describe 'Alternative cases' do
    describe 'When no slug is provided' do
      before do
        payload = {
          scopes: [new_scope.id.to_s],
          auth_token: session.token
        }
        put "/#{group.id.to_s}", payload.to_json
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: group.id.to_s,
          slug: 'test-group',
          scopes: [
            {id: new_scope.id.to_s, label: 'Scopes::Test'}
          ]
        )
      end
      describe 'Attributes of the updated record' do
        let!(:record) { Modusynth::Models::Permissions::Group.first }

        it 'Has not update the slug of the group' do
          expect(record.slug).to eq 'test-group'
        end
        it 'Has updated the scopes' do
          expect(record.scopes.map(&:id)).to eq [new_scope.id]
        end
      end
    end
    describe 'When no scopes are provided' do
      before do
        payload = {
          slug: 'new-slug',
          auth_token: session.token
        }
        put "/#{group.id.to_s}", payload.to_json
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: group.id.to_s,
          slug: 'new-slug',
          scopes: [
            {id: scopes.first.id.to_s, label: 'Scopes::First'},
            {id: scopes.last.id.to_s, label: 'Scopes::Second'},
          ]
        )
      end
      describe 'Attributes of the updated record' do
        let!(:record) { Modusynth::Models::Permissions::Group.first }

        it 'Has not modified the list of scopes' do
          expect(record.scopes.map(&:id)).to eq scopes.map(&:id)
        end
        it 'Has modified the slug correctly' do
          expect(record.slug).to eq 'new-slug'
        end
      end
    end
  end
  describe 'Error cases' do
    describe 'When the slug is too short' do
      before do
        put "/#{group.id.to_s}", {auth_token: session.token, slug: 'a'}.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'slug', message: 'minlength'
        )
      end
    end
    describe 'When the slug does not have the right format' do
      before do
        put "/#{group.id.to_s}", {auth_token: session.token, slug: 'patate123456'}.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'slug', message: 'format'
        )
      end
    end
  end
end
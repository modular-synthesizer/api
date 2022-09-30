RSpec.shared_examples 'ownership' do |verb, path, resource_factory|

  let!(:first_account) { create(:random_account) }
  let!(:second_account) { create(:random_account) }

  let!(:first_session) { create(:session, account: first_account) }
  let!(:second_session) { create(:session, account: second_account) }

  let!(:resource) { create(resource_factory, account: first_account) }

  let!(:payload) do
    pl = {auth_token: second_session.token }
    pl = pl.to_json if ['post', 'put'].include? verb
    pl
  end

  let!(:real_path) { path == '/:id' ? "/#{resource.id.to_s}" : path}

  describe 'Ownership errors' do
    describe 'When a user tries to access the resource of another user' do
      before do
        send(verb, real_path, payload)
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
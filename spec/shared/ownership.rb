# The shared example to check the errors regarding the ownership of a resource.
# This route mainly checks that a user cannot access a resource created by
# another user directly with the given route. in the path, the ":id" part is
# always replaced with the UUID of the resource created by the given factory.
RSpec.shared_examples 'ownership' do |verb, path, factory, field=:id|
  describe 'Ownership errors' do
    let!(:owner) { create(:account) }
    let!(:requester) { create(:account) }

    let!(:owner_s) { create(:session, account: owner) }
    let!(:requester_s) { create(:session, account: requester) }

    let!(:resource) { create(factory, account: owner) }

    let!(:payload) do
      payload = { auth_token: requester_s.token }
      ['post', 'put'].include?(verb) ? payload.to_json : payload
    end

    describe 'When a user is not the creator of the resource' do
      before do
        send(verb, path.gsub(':id', resource.send(field).to_s), payload)
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

# The shared example to check the errors regarding the ownership of a resource.
# This route mainly checks that a user cannot access a resource created by
# another user directly with the given route. in the path, the ":id" part is
# always replaced with the UUID of the resource created by the given factory.
RSpec.shared_examples 'ownership' do |verb, path, factory, field=:id|

  describe 'Ownership errors' do
    let!(:owner) { create(:account) }
    let!(:resource) { create(factory, account: owner) }

    let!(:requester) { create(:account) }
    let!(:session) { create(:session, account: requester) }

    let!(:payload) do
      payload = { auth_token: session.token }
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
    # An administrator can do anything on the data for any user.
    # These great powers come with a shit ton of responsibilities.
    describe 'Ownership override by admin' do
      
      let!(:admin) { create(:account, admin: true) }
      let!(:session) { create(:session, account: admin) }
  
      let!(:payload) do
        payload = { auth_token: session.token }
        ['post', 'put'].include?(verb) ? payload.to_json : payload
      end
  
      before do
        send(verb, path.gsub(':id', resource.send(field).to_s), payload)
      end
      it 'Returns anything ranging from 100 to 299 as there is no error' do
        expect(last_response.status).to be < 299
      end
      it 'Does not return an error body' do
        expect(last_response.body).to_not include_json(
          key: 'auth_token', message: 'forbidden'
        )
      end
    end
  end
end
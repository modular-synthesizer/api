RSpec.describe 'DELETE /memberships/:id' do
  def app
    Modusynth::Controllers::Memberships
  end

  let!(:account) { create(:random_admin) }
  let!(:session) { create(:session, account:) }

  let!(:guest) { create(:random_admin) }
  let!(:guest_session) { create(:session, account: guest) }

  let!(:synthesizer) do
    Modusynth::Services::Synthesizers.instance.create(account:, name: 'test synth')
  end

  describe 'Nominal case' do
    let!(:membership) { create(:membership, account: guest, synthesizer:, enum_type: :read) }

    before do
      delete "/#{membership.id.to_s}", { auth_token: session.token }
    end
    it 'Returns a 204 (No Content) status code' do
      expect(last_response.status).to be 204
    end
    it 'Has deleted the membership' do
      expect(guest.memberships.count).to be 0
    end
  end
  describe 'Alternative cases' do
    describe 'deleting a write membership' do
      let!(:membership) { create(:membership, account: guest, synthesizer:, enum_type: :write) }
  
      before do
        delete "/#{membership.id.to_s}", { auth_token: session.token }
      end
      it 'Returns a 204 (No Content) status code' do
        expect(last_response.status).to be 204
      end
      it 'Has deleted the membership' do
        expect(guest.memberships.count).to be 0
      end
    end
    describe 'When the user himself deletes their membership' do
      let!(:membership) { create(:membership, account: guest, synthesizer:) }
      let!(:guest_session) { create(:session, account: guest) }
  
      before do
        delete "/#{membership.id.to_s}", { auth_token: guest_session.token }
      end
      it 'Returns a 204 (No Content) status code' do
        expect(last_response.status).to be 204
      end
      it 'Has deleted the membership' do
        expect(guest.memberships.count).to be 0
      end
    end
    describe 'The membership is not found' do
      before do
        delete '/unknown', { auth_token: session.token }
      end
      it 'Returns a 204 (No Content) status code' do
        expect(last_response.status).to be 204
      end
    end
    describe 'The account is nor the creator of the synthesizer, neither the user in the membership' do
      let!(:membership) { create(:membership, account: guest, synthesizer:) }
      let!(:attacker) { create(:random_admin) }
      let!(:attacker_session) { create(:session, account: attacker) }

      before do
        delete '/unknown', { auth_token: attacker_session.token }
      end
      it 'Returns a 204 (No Content) status code' do
        expect(last_response.status).to be 204
      end
      it 'Has not deleted the membership' do
        expect(guest.memberships.count).to be 1
      end
    end
    describe 'The creator tries to delete their own membership' do
      before do
        delete "/#{account.memberships.first.id.to_s}", { auth_token: session.token }
      end
      it 'Returns a 204 (No Content) status code' do
        expect(last_response.status).to be 204
      end
      it 'Has not deleted the membership' do
        expect(account.memberships.count).to be 1
      end
    end
  end

  include_examples 'authentication', 'delete', '/id'
  include_examples 'scopes', 'delete', '/id'
end
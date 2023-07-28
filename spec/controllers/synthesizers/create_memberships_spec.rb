RSpec.describe 'GET /synthesizers/:id/memberships' do

  def app
    Modusynth::Controllers::Synthesizers
  end

  let!(:account) { create(:account) }
  let!(:session) { create(:session, account:) }
  let!(:synthesizer) do
    Modusynth::Services::Synthesizers.instance.create(account:, name: 'test synth')
  end

  let!(:guest) { create(:account) }
  let!(:guest_session) { create(:session, account: guest) }

  describe 'Nominal case' do
    before do
      post "/#{synthesizer.id.to_s}/memberships", {
        auth_token: session.token,
        account_id: guest.id.to_s
      }
    end
    it 'Returns a 201 (Created) status code' do
      expect(last_response.status).to be 201
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        type: 'read',
        x: 0,
        y: 0,
        scale: 1.0,
        synthesizer: {
          id: synthesizer.id.to_s,
          name: 'test synth'
        },
        account: {
          id: guest.id.to_s,
          username: guest.username
        }
      )
    end
    it 'Has created one membership' do
      expect(synthesizer.memberships.where(:enum_type.ne => 'creator').count).to be 1
    end
    describe 'The created membership' do
      let!(:membership) { guest.memberships.first }

      it 'Has the correct account' do
        expect(membership.account.id).to eq guest.id
      end
      it 'Has the correct synthesizer' do
        expect(membership.synthesizer.id).to eq synthesizer.id
      end
      it 'Has the correct type' do
        expect(membership.type).to eq :read
      end
      it 'Has the correct X coordinate' do
        expect(membership.x).to be 0
      end
      it 'Has the correct Y coordinate' do
        expect(membership.y).to be 0
      end
      it 'Has the correct scale' do
        expect(membership.scale).to be 1.0
      end
    end
  end
  describe 'Alternative cases' do
    describe 'Creating with a write permission' do
      before do
        post "/#{synthesizer.id.to_s}/memberships", {
          auth_token: session.token,
          account_id: guest.id.to_s,
          type: 'write'
        }
      end
      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          type: 'write',
          x: 0,
          y: 0,
          scale: 1.0,
          synthesizer: {
            id: synthesizer.id.to_s,
            name: 'test synth'
          },
          account: {
            id: guest.id.to_s,
            username: guest.username
          }
        )
      end
      it 'Has created the membership with the correct permission' do
        expect(guest.memberships.first.type).to eq :write
      end
    end
  end
  describe 'Error cases' do
    describe 'When the account is not given' do
      before do
        post "/#{synthesizer.id.to_s}/memberships", {
          auth_token: session.token,
          type: 'write'
        }
      end
      it 'Returns a 400 (Bad Request) status code ' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'account_id', message: 'required'
        )
      end
      it 'Has created no more membership in the synthesizer' do
        expect(synthesizer.memberships.count).to be 1
      end
      it 'Has created no membership in the account' do
        expect(guest.memberships.count).to be 0
      end
    end
    describe 'When the account is not found' do
      before do
        post "/#{synthesizer.id.to_s}/memberships", {
          auth_token: session.token,
          account_id: 'unknown',
          type: 'write'
        }
      end
      it 'Returns a 404 (Not Found) status code ' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'account_id', message: 'unknown'
        )
      end
      it 'Has created no more membership in the synthesizer' do
        expect(synthesizer.memberships.count).to be 1
      end
      it 'Has created no membership in the account' do
        expect(guest.memberships.count).to be 0
      end
    end
    describe 'When the synthesizer is not found' do
      before do
        post '/unknown/memberships', {
          auth_token: session.token,
          account_id: account.id.to_s,
          type: 'write'
        }
      end
      it 'Returns a 404 (Not Found) status code ' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'id', message: 'unknown'
        )
      end
      it 'Has created no more membership in the synthesizer' do
        expect(synthesizer.memberships.count).to be 1
      end
      it 'Has created no membership in the account' do
        expect(guest.memberships.count).to be 0
      end
    end
    describe 'When the user is not the creator of the synthesizer' do
      before do
        post "/#{synthesizer.id.to_s}/memberships", {
          auth_token: guest_session.token,
          account_id: account.id.to_s,
          type: 'write'
        }
      end
      it 'Returns a 403 (Forbidden) status code ' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'auth_token', message: 'forbidden'
        )
      end
      it 'Has created no more membership in the synthesizer' do
        expect(synthesizer.memberships.count).to be 1
      end
      it 'Has created no membership in the account' do
        expect(guest.memberships.count).to be 0
      end
    end
    describe 'when you try to create another :creator type membership' do
      before do
        post "/#{synthesizer.id.to_s}/memberships", {
          auth_token: session.token,
          account_id: guest.id.to_s,
          type: 'creator'
        }
      end
      it 'Returns a 400 (Bad Request) status code ' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'type', message: 'value'
        )
      end
      it 'Has created no more membership in the synthesizer' do
        expect(synthesizer.memberships.count).to be 1
      end
      it 'Has created no membership in the account' do
        expect(guest.memberships.count).to be 0
      end
    end
    describe 'When the membership already exists' do
      before do
        post "/#{synthesizer.id.to_s}/memberships", {
          auth_token: session.token,
          account_id: account.id.to_s,
          type: 'creator'
        }
      end
      it 'Returns a 400 (Bad Request) status code ' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'account_id', message: 'uniq'
        )
      end
      it 'Has created no more membership in the synthesizer' do
        expect(synthesizer.memberships.count).to be 1
      end
      it 'Has created no membership in the account' do
        expect(guest.memberships.count).to be 0
      end
    end
  end
end
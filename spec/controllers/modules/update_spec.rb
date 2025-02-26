describe Modusynth::Controllers::Modules do
  def app
    Modusynth::Controllers::Modules
  end

  let!(:account) { create(:random_admin) }
  let!(:session) { create(:session, account: account) }

  describe 'PUT /:id' do
    let!(:synth) do
      Modusynth::Services::Synthesizers.instance.create(account:, name: 'test synth', racks: 2)
    end
    let!(:node) { create(:VCA_module, synthesizer: synth) }

    describe 'Nominal case' do
      before do
        payload = {slot: 31, rack: 12, auth_token: session.token }
        put "/#{node.id.to_s}", payload.to_json
        node.reload
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          slot: 31, rack: 12
        })
      end
      it 'Has update the slot' do
        expect(node.slot).to be 31
      end
      it 'Has updated the rack' do
        expect(node.rack).to be 12
      end
    end
    describe 'Alternative cases' do
      describe 'When the update is done by another user with the write permission' do
        let!(:other_account) { create(:random_admin) }
        let!(:other_session) { create(:session, account: other_account) }
        let!(:membership) { create(:membership, account: other_account, synthesizer: synth, enum_type: 'write') }

        before do
          payload = { rack: 45, slot: -2, auth_token: other_session.token }
          put "/#{node.id.to_s}", payload.to_json
          node.reload
        end
        it 'Returns a 200 (OK) status code' do
          expect(last_response.status).to be 200
        end
        it 'Has updated the value' do
          expect(node.rack).to be 45
          expect(node.slot).to be (-2)
        end
      end
    end
    describe 'Error cases' do
      describe 'When the update is made by another user with the read permissions' do
        let!(:other_account) { create(:random_admin) }
        let!(:other_session) { create(:session, account: other_account) }
        let!(:membership) { create(:membership, account: other_account, synthesizer: synth, enum_type: 'read') }

        before do
          payload = { rack: 45, slot: -2, auth_token: other_session.token }
          put "/#{node.id.to_s}", payload.to_json
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
      describe 'When the update is made by another user not participating in the synthesizer' do
        let!(:other_account) { create(:random_admin) }
        let!(:other_session) { create(:session, account: other_account) }

        before do
          payload = { rack: 0, slot: 0, auth_token: other_session.token }
          put "/#{node.id.to_s}", payload.to_json
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

    include_examples 'authentication', 'put', '/:id'
    include_examples 'scopes', 'put', '/:id'
  end
end
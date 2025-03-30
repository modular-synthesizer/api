describe Modusynth::Controllers::Parameters do
  def app
    Modusynth::Controllers::Parameters
  end

  let!(:account) { create(:random_admin) }
  let!(:session) { create(:session, account: account) }

  describe 'PUT /:id' do
    let!(:synth) do
      Modusynth::Services::Synthesizers.instance.create(account:, name: 'test synth', racks: 2)
    end
    let!(:node) { create(:VCA_module, synthesizer: synth) }
    let!(:param_id) { node.parameters.first.id.to_s }

    describe 'Nominal case' do
      before do
        payload = {value: 2, auth_token: session.token, t: 1989 }
        put "/#{param_id}", payload.to_json
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the timestamp correctly' do
        expect(last_response.body).to include_json(
          t: 1989
        )
      end
      it 'Has update the gain value' do
        node.reload
        expect(node.parameters.first.value).to be 2.0
      end
    end
    describe 'Alternative cases' do
      describe 'When the update is done by another user with the write permission' do
        let!(:other_account) { create(:random_admin) }
        let!(:other_session) { create(:session, account: other_account) }
        let!(:membership) { create(:membership, account: other_account, synthesizer: synth, enum_type: 'write') }

        before do
          payload = { value: 2, auth_token: other_session.token }
          put "/#{param_id}", payload.to_json
        end
        it 'Returns a 200 (OK) status code' do
          expect(last_response.status).to be 200
        end
        it 'Has updated the value' do
          node.reload
          expect(node.parameters.first.value).to be 2.0
        end
      end
    end
    describe 'Error cases' do
      describe 'When the value is below the minimum' do
        before do
          payload = { value: -1, auth_token: session.token }
          put "/#{param_id}", payload.to_json
        end

        it 'Returns a 404 (Not Found) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'value', message: 'boundaries'
          )
        end
      end
      describe 'When the value is above the maximum' do
        before do
          payload = { value: 101, auth_token: session.token }
          put "/#{param_id}", payload.to_json
        end

        it 'Returns a 404 (Not Found) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'value', message: 'boundaries'
          )
        end
      end
      describe 'When the update is made by another user with the read permissions' do
        let!(:other_account) { create(:random_admin) }
        let!(:other_session) { create(:session, account: other_account) }
        let!(:membership) { create(:membership, account: other_account, synthesizer: synth, enum_type: 'read') }

        before do
          payload = { valuz: 2, auth_token: other_session.token }
          put "/#{param_id}", payload.to_json
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
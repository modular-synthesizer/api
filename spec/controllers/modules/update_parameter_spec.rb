# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

RSpec.describe Modusynth::Controllers::Modules do
  def app
    Modusynth::Controllers::Modules
  end

  let!(:account) { create(:random_admin) }
  let!(:session) { create(:session, account: account) }
  let!(:synthesizer) do
    Modusynth::Services::Synthesizers.instance.create(account:, name: 'test synth', racks: 2)
  end
  let!(:node) { create(:VCA_module, synthesizer:) }
  let!(:parameter) { node.parameters.first }

  let!(:twenty_seconds_ago) { DateTime.now - (20.0 / 86_400) }
  let!(:fourty_seconds_ago) { DateTime.now - (40.0 / 86_400) }

  describe 'PUT /:module_id/parameters/:id' do
    describe 'Nominal case' do
      before do
        payload = { auth_token: session.token, value: 42.0 }
        put "/#{node.id}/parameters/#{parameter.id}", payload.to_json
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: parameter.id.to_s,
          value: 42.0,
          blocked: false
        )
      end
      it 'Has correctly edited the value' do
        parameter.reload
        expect(parameter.value).to be 42.0
      end
    end
    describe 'Alternative cases' do
      describe 'Blocking a parameter' do
        # Steps :
        # 1. a user named USER_1 has blocked a parameter
        # 2. for any given reason, USER_1 tries to block the same parameter again.
        describe 'The parameter has previously been blocked by the same user' do
          before do
            parameter.last_blocked_date = twenty_seconds_ago
            parameter.blocker = session.account
            parameter.save!
            payload = { auth_token: session.token, blocked: true, value: 42.0 }
            put "/#{node.id}/parameters/#{parameter.id}", payload.to_json
            parameter.reload
          end
          it 'Returns a 200 (OK) status code' do
            expect(last_response.status).to be 200
          end
          it 'Returns the correct body' do
            expect(last_response.body).to include_json(
              id: parameter.id.to_s,
              value: 50.0,
              blocked: true
            )
          end
          it 'Has updated the blocked date to a more recent date' do
            expect(parameter.last_blocked_date > twenty_seconds_ago).to be true
          end
          it 'Has NOT modified the value as it is only blocking the parameter' do
            expect(parameter.value).to be 50.0
          end
        end
        # Steps :
        # 1. a user named USER_1 has blocked a parameter
        # 2. thirty seconds pass
        # 3. another user named USER_2 tries to block the same parameter
        describe 'The parameter has been blocked for more than 30s by another user' do
          let!(:other_account) { create(:random_admin) }
          let!(:other_session) { create(:session, account: other_account) }
          let!(:membership) do
            Modusynth::Models::Social::Membership.create(synthesizer:, account: other_account, type: 'write')
          end

          before do
            parameter.last_blocked_date = fourty_seconds_ago
            parameter.blocker = session.account
            parameter.save!
            payload = { auth_token: other_session.token, blocked: true }
            put "/#{node.id}/parameters/#{parameter.id}", payload.to_json
            parameter.reload
          end
          it 'Returns a 200 (OK) status code' do
            expect(last_response.status).to be 200
          end
          it 'Returns the correct body' do
            expect(last_response.body).to include_json(
              id: parameter.id.to_s,
              value: 50.0,
              blocked: true
            )
          end
          it 'Has updated the blocker with the new value' do
            expect(parameter.blocker.id.to_s).to eq other_account.id.to_s
          end
          it 'Has updated the blocked date to a more recent date' do
            expect(parameter.last_blocked_date > fourty_seconds_ago).to be true
          end
        end
      end
      describe 'Unblocking a parameter' do
        describe 'The parameter is not even blocked' do
          before do
            payload = { auth_token: session.token, blocked: false }
            put "/#{node.id}/parameters/#{parameter.id}", payload.to_json
            parameter.reload
          end
          it 'Returns a 200 (OK) status code' do
            expect(last_response.status).to be 200
          end
          it 'Returns the correct body' do
            expect(last_response.body).to include_json(
              id: parameter.id.to_s,
              value: 50.0,
              blocked: false
            )
          end
          it 'Has not modified the blocker account' do
            expect(parameter.blocker).to be nil
          end
          it 'Has not modified the last blocked date' do
            expect(parameter.last_blocked_date).to be nil
          end
        end
        describe 'The parameter was blocked for more than 30s by another user' do
          let!(:other_account) { create(:random_admin) }
          let!(:other_session) { create(:session, account: other_account) }
          let!(:membership) do
            Modusynth::Models::Social::Membership.create(synthesizer:, account: other_account, type: 'write')
          end

          before do
            parameter.last_blocked_date = fourty_seconds_ago
            parameter.blocker = session.account
            parameter.save!
            payload = { auth_token: other_session.token, blocked: false, value: 42.0 }
            put "/#{node.id}/parameters/#{parameter.id}", payload.to_json
            parameter.reload
          end
          it 'Returns a 200 (OK) status code' do
            expect(last_response.status).to be 200
          end
          it 'Returns the correct body' do
            expect(last_response.body).to include_json(
              value: 42.0,
              blocked: false
            )
          end
          it 'Has set the blocker account to nil as it officially releases the parameter' do
            expect(parameter.blocker).to be nil
          end
          it 'Has set the blocked date to nil for the same reason' do
            expect(parameter.last_blocked_date).to be nil
          end
        end
        describe 'The parameter was blocked by the same user' do
          before do
            parameter.last_blocked_date = twenty_seconds_ago
            parameter.blocker = session.account
            parameter.save!
            payload = { auth_token: session.token, blocked: false, value: 42.0 }
            put "/#{node.id}/parameters/#{parameter.id}", payload.to_json
            parameter.reload
          end
          it 'Returns a 200 (OK) status code' do
            expect(last_response.status).to be 200
          end
          it 'Returns the correct body' do
            expect(last_response.body).to include_json(
              value: 42.0,
              blocked: false
            )
          end
          it 'Has set the blocker account to nil as it officially releases the parameter' do
            expect(parameter.blocker).to be nil
          end
          it 'Has set the blocked date to nil for the same reason' do
            expect(parameter.last_blocked_date).to be nil
          end
        end
      end
    end
    describe 'Error cases' do
      describe 'The value is below the minimum threshold' do
        before do
          payload = { value: parameter.template.minimum - 1, blocked: false, auth_token: session.token }
          put "/#{node.id}/parameters/#{parameter.id}", payload.to_json
          parameter.reload
        end
        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'value', message: 'boundaries'
          )
        end
        it 'Has not modified the value of the parameter' do
          expect(parameter.value).to be 50.0
        end
      end
      describe 'The value is above the maximum threshold' do
        before do
          payload = { value: parameter.template.maximum + 1, blocked: false, auth_token: session.token }
          put "/#{node.id}/parameters/#{parameter.id}", payload.to_json
          parameter.reload
        end
        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'value', message: 'boundaries'
          )
        end
        it 'Has not modified the value of the parameter' do
          expect(parameter.value).to be 50.0
        end
      end
      describe 'The parameter is blocked by another user' do
        let!(:other_account) { create(:random_admin) }
        before do
          parameter.blocker = other_account
          parameter.last_blocked_date = twenty_seconds_ago
          parameter.save!
          payload = { value: parameter.value + 1, blocked: false, auth_token: session.token }
          put "/#{node.id}/parameters/#{parameter.id}", payload.to_json
        end
        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'value', message: 'blocked'
          )
        end
        it 'Has not modified the value of the parameter' do
          expect(parameter.value).to be 50.0
        end
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength

RSpec.describe Modusynth::Controllers::Synthesizers do

  def app
    Modusynth::Controllers::Synthesizers
  end

  let!(:babausse) { create(:babausse) }
  let!(:session) { create(:session, account: babausse) }

  describe 'GET /:id' do
    describe 'Nominal case' do
      let!(:synthesizer) do
        Modusynth::Services::Synthesizers.instance.create(account: babausse, name: 'test synth')
      end
      before do
        get "/#{synthesizer.id.to_s}", {auth_token: session.token}
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: synthesizer.id.to_s,
          members: [
            {
              id: synthesizer.creator.id.to_s,
              username: babausse.username,
              account_id: babausse.id.to_s,
              type: 'creator'
            }
          ],
          name: synthesizer.name,
          x: 0,
          y: 0,
          scale: 1.0
        )
      end
    end
    describe 'Alternative cases' do
      describe 'When the synthesizer has memberships' do
        let!(:synthesizer) do
          Modusynth::Services::Synthesizers.instance.create(account: babausse, name: 'test synth')
        end

        let!(:guest_1) { create(:random_admin) }
        let!(:guest_2) { create(:random_admin) }

        let!(:membership_1) { create(:membership, account: guest_1, synthesizer:, enum_type: :read) }
        let!(:membership_2) { create(:membership, account: guest_2, synthesizer:, enum_type: :write) }

        before do
          get "/#{synthesizer.id.to_s}", {auth_token: session.token}
        end
        it 'Returns a 200 (OK) status code' do
          expect(last_response.status).to be 200
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            id: synthesizer.id.to_s,
            members: [
              {
                id: synthesizer.creator.id.to_s,
                username: babausse.username,
                account_id: babausse.id.to_s,
                type: 'creator'
              },
              {
                id: membership_1.id.to_s,
                account_id: guest_1.id.to_s,
                username: guest_1.username,
                type: 'read'
              },
              {
                id: membership_2.id.to_s,
                account_id: guest_2.id.to_s,
                username: guest_2.username,
                type: 'write'
              }
            ]
          )
        end
      end
    end
    describe 'Error cases' do
      describe 'The synthesizer does not exist' do
        before do
          get '/unknown', {auth_token: session.token}
        end
        it 'Returns a 404 (Not Found) status code' do
          expect(last_response.status).to be 404
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'id', message: 'unknown'
          )
        end
      end
    end
  end

  include_examples 'authentication', 'get', "/anything"
  include_examples 'scopes', 'get', "/anything"
end
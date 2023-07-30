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
          creator: {
            username: babausse.username,
            id: babausse.id.to_s
          },
          name: synthesizer.name,
          x: 0,
          y: 0,
          scale: 1.0,
          racks: 1,
          slots: 50
        )
      end
    end
    describe 'Alternative cases' do
      describe 'When the synthesizer has memberships' do
        let!(:synthesizer) do
          Modusynth::Services::Synthesizers.instance.create(account: babausse, name: 'test synth')
        end

        let!(:guest_1) { create(:account) }
        let!(:guest_2) { create(:account) }

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
            creator: {
              username: babausse.username,
              id: babausse.id.to_s
            },
            members: [
              { id: guest_1.id.to_s, username: guest_1.username, type: 'read' },
              { id: guest_2.id.to_s, username: guest_2.username, type: 'write' }
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
end
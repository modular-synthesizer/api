RSpec.describe Modusynth::Controllers::Synthesizers do
  def app
    Modusynth::Controllers::Synthesizers
  end

  let!(:babausse) { create(:babausse) }
  let!(:session) { create(:session, account: babausse) }

  describe 'GET /' do
    describe 'empty list' do
      before do
        get '/', {auth_token: session.token}
      end

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns an empty list' do
        expect(JSON.parse(last_response.body)).to eq([])
      end
    end
    describe 'populated list' do
      let!(:synthesizer) {
        Modusynth::Services::Synthesizers.instance.create(name: 'test synth', account: session.account)
      }
      before do
        get '/', {auth_token: session.token}
      end

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json([
          {
            id: a_kind_of(String),
            members: [
              {
                id: synthesizer.creator.id.to_s,
                username: babausse.username,
                account_id: babausse.id.to_s,
                type: 'creator'
              }
            ],
            name: 'test synth',
            x: 0,
            y: 0,
            scale: 1
          }
        ])
      end
    end
    describe 'Restricted list depending on the ownership' do
      let!(:other_user) { create(:random_admin) }
      let!(:other_session) { create(:session, account: other_user) }
      let!(:synthesizer) { create(:synthesizer, name: 'test synth') }
      let!(:other_synth) { create(:synthesizer, name: 'test synth') }

      before do
        Modusynth::Models::Social::Membership.create(account: other_user, synthesizer: other_synth, enum_type: 'creator')
        Modusynth::Models::Social::Membership.create(account: babausse, synthesizer: other_synth, enum_type: 'write')
        Modusynth::Models::Social::Membership.create(account: babausse, synthesizer: synthesizer, enum_type: 'creator')
      end

      describe 'when you ask for owned synthesizers' do
        before do
          get '/', { auth_token: session.token, type: 'creator' }
        end
        it 'Returns a 200 (OK) status code' do
          expect(last_response.status).to be 200
        end
        describe 'The returned body' do
          let!(:body) { JSON.parse(last_response.body) }
          it 'Returns a list of 1 item' do
            expect(body.count).to be 1
          end
          it 'Returns the correct synthesizer' do
            expect(body[0]['id']).to eq synthesizer.id.to_s
          end
        end
      end
      describe 'when you ask for not owned synthesizers' do
        before do
          get '/', { auth_token: session.token, type: [ 'read', 'write' ] }
        end
        it 'Returns a 200 (OK) status code' do
          expect(last_response.status).to be 200
        end
        describe 'The returned body' do
          let!(:body) { JSON.parse(last_response.body) }
          it 'Returns a list of 1 item' do
            expect(body.count).to be 1
          end
          it 'Returns the correct synthesizer' do
            expect(body[0]['id']).to eq other_synth.id.to_s
          end
        end
      end
      describe 'When you still want all your synths, owned or not' do
        before do
          get '/', { auth_token: session.token }
        end
        it 'Returns a 200 (OK) status code' do
          expect(last_response.status).to be 200
        end
        it 'Returns an empty list if there are no owned synthesizers' do
          expect(JSON.parse(last_response.body).count).to be 2
        end
      end
    end
    describe 'List with deleted synthesizers in it' do

      let!(:service) { Modusynth::Services::Synthesizers.instance }
      let!(:synthesizer) { service.create(name: 'test synth', account: session.account) }

      before do
        service.remove(id: synthesizer.id, session:)
      end

      before do
        get '/', {auth_token: session.token}
      end

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns an empty list' do
        expect(JSON.parse(last_response.body)).to eq([])
      end
    end
  end

  include_examples 'authentication', 'get', '/'
  include_examples 'scopes', 'get', '/'
end
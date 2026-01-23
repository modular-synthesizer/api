# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe Modusynth::Controllers::Synthesizers do
  def app
    Modusynth::Controllers::Synthesizers
  end

  let!(:account) { create(:admin) }
  let!(:auth_token) { create_token(account) }
  let!(:uri) { '/admin-uuid/synthesizers' }

  describe 'GET /' do
    describe 'empty list' do
      before do
        get uri, { auth_token: }
      end

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns an empty list' do
        expect(JSON.parse(last_response.body)).to eq([])
      end
    end
    describe 'populated list' do
      let!(:synthesizer) do
        post uri, { name: 'test synth', auth_token: }
        Modusynth::Models::Synthesizer.find_by(name: 'test synth')
      end

      before do
        get uri, { auth_token: }
      end

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        membership = { id: synthesizer.creator.id.to_s, username: 'admin', account_id: 'admin-uuid', type: 'creator' }
        expectation = [{ id: a_kind_of(String), members: [membership], name: 'test synth', x: 0, y: 0, scale: 1 }]
        expect(last_response.body).to include_json(expectation)
      end
    end
    describe 'Restricted list depending on the ownership' do
      let!(:other_user) { create(:random_admin) }
      let!(:other_token) { create_token(other_user) }
      let!(:synthesizer) { create(:synthesizer, name: 'test synth') }
      let!(:other_synth) { create(:synthesizer, name: 'test synth') }
      let!(:model) { Modusynth::Models::Social::Membership }

      before do
        model.create(account: other_user, synthesizer: other_synth, enum_type: 'creator')
        model.create(account:, synthesizer: other_synth, enum_type: 'write')
        model.create(account:, synthesizer: synthesizer, enum_type: 'creator')
      end

      describe 'when you ask for owned synthesizers' do
        before do
          get uri, { auth_token:, type: 'creator' }
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
          get uri, { auth_token:, type: %w[read write] }
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
          get uri, { auth_token: }
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
      let!(:synthesizer) { service.create(name: 'test synth', account:) }

      before do
        delete "/admin-uuid/synthesizers/#{synthesizer.id}", { auth_token: }
        get uri, { auth_token: }
      end

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns an empty list' do
        expect(JSON.parse(last_response.body)).to eq([])
      end
    end
  end

  include_examples 'authentication', 'GET /synthesizers'
end

# rubocop:enable Metrics/BlockLength

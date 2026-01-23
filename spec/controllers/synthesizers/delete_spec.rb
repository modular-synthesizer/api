# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe Modusynth::Controllers::Synthesizers do
  def app
    Modusynth::Controllers::Synthesizers
  end

  let!(:account) { create(:admin) }
  let!(:auth_token) { create_token(account) }

  describe 'DELETE /:id' do
    let!(:synthesizer) do
      post '/admin-uuid/synthesizers', { name: 'test synth', auth_token: }.to_json
      Modusynth::Models::Synthesizer.find_by(name: 'test synth')
    end
    let!(:uri) { "/admin-uuid/synthesizers/#{synthesizer.id}" }
    let!(:node) { create(:VCA_module, synthesizer: synthesizer) }

    describe 'Nominal case' do
      before do
        delete uri, { auth_token: }
      end

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 204
      end
      it 'Has deleted the synthesizer' do
        expect(Modusynth::Models::Synthesizer.deleted.where(id: synthesizer.id).count).to be 1
      end
    end
    describe 'Alternative cases' do
      describe 'There were memberships in the synthesizer' do
        let!(:guest) { create(:random_admin) }
        let!(:guest_membership) { create(:membership, synthesizer:, account: guest) }

        before do
          delete uri, { auth_token: }
        end
        it 'Returns a 204 (No Content) status code' do
          expect(last_response.status).to be 204
        end
        it 'Has deleted the synthesizer' do
          expect(Modusynth::Models::Synthesizer.deleted.count).to be 1
        end
      end
      describe 'Two consecutive calls' do
        before do
          delete uri, { auth_token: }
          delete uri, { auth_token: }
        end

        it 'Returns a 204 (No Content) status code' do
          expect(last_response.status).to be 204
        end
      end
      describe 'Not owner of the resource' do
        let!(:attacker) { create(:random_admin) }
        let!(:attacker_token) { create_token(attacker) }

        before do
          delete "/#{attacker.uuid}/synthesizers/#{synthesizer.id}", { auth_token: attacker_token }
        end

        it 'Returns a 204 (No Content) status code' do
          expect(last_response.status).to be 204
        end
        it 'Has not deleted the synthesizer' do
          expect(Modusynth::Models::Synthesizer.find(synthesizer.id)).to_not be_nil
        end
      end
    end
  end

  include_examples 'authentication', 'DELETE /synthesizers/synthesizer-id'
end

# rubocop:enable Metrics/BlockLength

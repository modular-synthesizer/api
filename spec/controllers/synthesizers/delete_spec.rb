RSpec.describe Modusynth::Controllers::Synthesizers do

  def app
    Modusynth::Controllers::Synthesizers
  end

  let!(:babausse) { create(:babausse) }
  let!(:session) { create(:session, account: babausse) }

  describe 'DELETE /:id' do
    let!(:synthesizer) do
      Modusynth::Services::Synthesizers.instance.create(account: babausse, name: 'test synth')
    end
    let!(:node) { create(:VCA_module, synthesizer: synthesizer) }
    
    describe 'Nominal case' do
      before { delete "/#{synthesizer.id.to_s}", {auth_token: session.token} }
      
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
          delete "/#{synthesizer.id.to_s}", {auth_token: session.token}
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
          delete "/#{synthesizer.id.to_s}", {auth_token: session.token}
          delete "/#{synthesizer.id.to_s}", {auth_token: session.token}
        end

        it 'Returns a 204 (No Content) status code' do
          expect(last_response.status).to be 204
        end
      end
      describe 'Not owner of the resource' do
        let!(:attacker) { create(:random_admin) }
        let!(:attacker_session) { create(:session, account: attacker) }

        before do
          delete "/#{synthesizer.id.to_s}", {auth_token: attacker_session.token}
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

  include_examples 'authentication', 'delete', "/anything"
  include_examples 'scopes', 'delete', "/anything"
end
describe Modusynth::Controllers::Modules do
  def app
    Modusynth::Controllers::Modules
  end

  let!(:account) { create(:random_admin) }
  let!(:session) { create(:session, account: account) }
  let!(:synthesizer) { Modusynth::Services::Synthesizers.instance.create(account:, name: 'test synth') }

  let!(:guest) { create(:random_admin) }
  let!(:guest_session) { create(:session, account: guest) }

  describe 'DELETE /:id' do
    let(:node) { create(:VCA_module, synthesizer: synthesizer) }

    describe 'Nominal case' do
      before do
        delete "/#{node.id.to_s}", {auth_token: session.token}
      end
      
      it 'Returns a 204 (No Content) status code' do
        expect(last_response.status).to be 204
      end
      it 'Has deleted the module' do
        expect(Modusynth::Models::Module.all.size).to be 0
      end
    end
    describe 'Alternative cases' do
      describe 'Two consecutive calls' do
        before do
          delete "/#{node.id.to_s}", {auth_token: session.token}
          delete "/#{node.id.to_s}", {auth_token: session.token}
        end

        it 'Returns a 204 (No Content) status code' do
          expect(last_response.status).to be 204
        end
      end
      describe 'The module is deleted by another user with the write permission' do
        let!(:membership) { create(:membership, account: guest, synthesizer:, enum_type: 'write') }

        before do
          delete "/#{node.id.to_s}", {auth_token: guest_session.token}
        end

        it 'Returns a 204 (No Content) status code' do
          expect(last_response.status).to be 204
        end
        it 'Has deleted the module' do
          synthesizer.reload
          expect(synthesizer.modules.count).to be 0
        end
      end
      describe 'The module is deleted by another user with the read permission' do
        let!(:membership) { create(:membership, account: guest, synthesizer:, enum_type: 'read') }
        
        before do
          delete "/#{node.id.to_s}", {auth_token: guest_session.token}
        end

        it 'Returns a 204 (No Content) status code' do
          expect(last_response.status).to be 204
        end
        it 'Has not deleted the module' do
          synthesizer.reload
          expect(synthesizer.modules.count).to be 1
        end
      end
    end

    include_examples 'authentication', 'delete', '/:id'
    include_examples 'scopes', 'delete', '/:id'
  end
end
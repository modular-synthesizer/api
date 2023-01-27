describe Modusynth::Controllers::Modules do
  def app
    Modusynth::Controllers::Modules
  end

  let!(:account) { create(:account) }
  let!(:session) { create(:session, account: account) }
  let!(:synthesizer) { create(:synthesizer, account: account) }

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
    end

    include_examples 'authentication', 'delete', '/:id'
  end
end
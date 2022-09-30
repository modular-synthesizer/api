RSpec.describe Modusynth::Controllers::Synthesizers do

  def app
    Modusynth::Controllers::Synthesizers
  end

  let!(:babausse) { create(:babausse) }
  let!(:session) { create(:session, account: babausse) }

  describe 'DELETE /:id' do
    let!(:synthesizer) { create(:synthesizer, account: babausse) }
    let!(:node) { create(:VCA_module, synthesizer: synthesizer) }
    
    describe 'Nominal case' do
      before { delete "/#{synthesizer.id.to_s}", {auth_token: session.token} }
      
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(message: 'deleted')
      end
      it 'Has deleted the synthesizer' do
        expect(Modusynth::Models::Synthesizer.all.size).to be 0
      end
      it 'Has deleted all the modules linked to it' do
        expect(Modusynth::Models::Module.all.size).to be 0
      end
    end
    describe 'Alternative cases' do
      describe 'Two consecutive calls' do
        before do
          delete "/#{synthesizer.id.to_s}", {auth_token: session.token}
          delete "/#{synthesizer.id.to_s}", {auth_token: session.token}
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

  include_examples 'authentication::synthesizers', 'get', "/#{id}", ownership: true

  include_examples 'ownership', 'get', '/:id', :synthesizer
end
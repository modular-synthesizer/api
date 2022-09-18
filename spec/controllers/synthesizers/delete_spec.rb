RSpec.describe Modusynth::Controllers::Synthesizers do
  def app
    Modusynth::Controllers::Synthesizers
  end

  describe 'DELETE /:id' do
    let!(:node) { create(:VCA_module) }
    let!(:synthesizer) { node.synthesizer }
    
    describe 'Nominal case' do
      before { delete "/#{synthesizer.id.to_s}" }
      
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
          delete "/#{synthesizer.id.to_s}"
          delete "/#{synthesizer.id.to_s}"
        end

        it 'Returns a 200 (OK) status code' do
          expect(last_response.status).to be 200
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(message: 'deleted')
        end
      end
    end
  end
end
RSpec.describe Modusynth::Controllers::Synthesizers do
  def app
    Modusynth::Controllers::Synthesizers
  end

  describe 'GET /' do
    describe 'empty list' do
      before { get '/' }

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns an empty list' do
        expect(JSON.parse(last_response.body)).to eq({'synthesizers' => []})
      end
    end
    describe 'populated list' do
      let!(:synthesizer) {
        Modusynth::Services::Synthesizers.instance.create({'name' => 'test synth'})
      }
      before { get '/' }
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(JSON.parse(last_response.body)).to eq({'synthesizers' => [
          {
            'id' => Modusynth::Models::Synthesizer.first.id.to_s,
            'name' => 'test synth'
          }
        ]})
      end
    end
  end
  describe 'POST /' do
    describe 'Nominal case' do
      before { post '/', {name: 'test synth'}.to_json }

      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: Modusynth::Models::Synthesizer.first.id.to_s,
          name: 'test synth'
        )
      end
      describe 'Created synthesizer' do
        let!(:synth) { Modusynth::Models::Synthesizer.first }

        it 'has the correct name' do
          expect(synth.name).to eq 'test synth'
        end
      end
    end
    describe 'Error cases' do
      describe 'Name not given' do
        before { post '/' }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'name', message: 'required'
          )
        end
      end
      describe 'Name too short' do
        before { post '/', {name: 'foo'}.to_json }
        
        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'name', message: 'length'
          )
        end
      end
    end
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
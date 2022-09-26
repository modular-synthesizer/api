RSpec.describe Modusynth::Controllers::Synthesizers do
  def app
    Modusynth::Controllers::Synthesizers
  end

  let!(:babausse) { create(:babausse) }
  let!(:session) { create(:session, account: babausse) }

  describe 'POST /' do
    describe 'Nominal case' do
      before { post '/', {name: 'test synth', auth_token: session.token}.to_json }

      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: Modusynth::Models::Synthesizer.first.id.to_s,
          name: 'test synth',
          racks: 1,
          slots: 50,
          x: 0,
          y: 0,
          scale: 1.0
        )
      end
      describe 'Created synthesizer' do
        let!(:synth) { Modusynth::Models::Synthesizer.first }

        it 'has the correct name' do
          expect(synth.name).to eq 'test synth'
        end
        it 'Has the correct owner' do
          expect(synth.account.username).to eq 'babausse'
        end
      end
    end
    describe 'Alternative cases' do
      describe 'The number of racks is given' do
        before { post '/', {name: 'test synth', racks: 3, auth_token: session.token}.to_json }

        it 'Returns a 201 (Created) status code' do
          expect(last_response.status).to be 201
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(racks: 3)
        end
      end
      describe 'The number of slots is given' do
        before { post '/', {name: 'test synth', slots: 100, auth_token: session.token}.to_json }

        it 'Returns a 201 (Created) status code' do
          expect(last_response.status).to be 201
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(slots: 100)
        end
      end
    end
    describe 'Error cases' do
      describe 'Name not given' do
        before { post '/', {auth_token: session.token}.to_json }

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
        before { post '/', {name: 'foo', auth_token: session.token}.to_json }
        
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

  include_examples 'authentication', 'post', '/'
end
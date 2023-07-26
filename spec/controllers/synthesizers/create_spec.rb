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
          scale: 1.0,
          voices: 1
        )
      end
      describe 'Created synthesizer' do
        let!(:synth) { Modusynth::Models::Synthesizer.first }

        it 'has the correct name' do
          expect(synth.name).to eq 'test synth'
        end
        it 'Has the correct number of racks' do
          expect(synth.racks).to be 1
        end
        it 'Has the correct number of slots' do
          expect(synth.slots).to be 50
        end
        it 'Has the correct number of voices' do
          expect(synth.voices).to be 1
        end
      end
      describe 'The created membership' do
        let!(:synth) { Modusynth::Models::Synthesizer.first }
        let!(:membership) { synth.memberships.first }

        it 'Has created only one membership' do
          expect(synth.memberships.count).to be 1
        end
        it 'Has created a membership with the correct account' do
          expect(membership.account.id).to eq babausse.id
        end
        it 'Has initialized the membership with the correct X' do
          expect(membership.x).to be 0
        end
        it 'Has initialized the membership with the correct Y' do
          expect(membership.y).to be 0
        end
        it 'Has initialized the membership with the correct scale' do
          expect(membership.scale).to eq 1.0
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
      describe 'The number of polyphony voices is given' do
        before { post '/', {name: 'test synth', voices: 64, auth_token: session.token}.to_json }

        it 'Returns a 201 (Created) status code' do
          expect(last_response.status).to be 201
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(voices: 64)
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
      describe 'Voices number below 1' do
        before { post '/', {name: 'test-name', voices: 0, auth_token: session.token}.to_json }
        
        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'voices', message: 'value'
          )
        end
      end
      describe 'Voices over 256' do
        before { post '/', {name: 'test-name', voices: 257, auth_token: session.token}.to_json }
        
        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'voices', message: 'value'
          )
        end
      end
    end
  end

  include_examples 'authentication', 'post', '/'
end
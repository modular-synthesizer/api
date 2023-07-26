RSpec.describe 'POST /links' do
  def app
    ::Modusynth::Controllers::Links
  end

  let!(:account) { create(:babausse) }
  let!(:session) { create(:session, account:) }
  let!(:synthesizer) do
    Modusynth::Services::Synthesizers.instance.create(account:, name: 'test synth')
  end
  let!(:tool) do
    create(:VCA, ports: [
      build(:input_port),
      build(:output_port)
    ])
  end
  let!(:mod) { create(:module, tool:, synthesizer:) }
  let!(:from) { mod.ports.first.id.to_s }
  let!(:to) { mod.ports.last.id.to_s }

  describe 'Nominal case' do
    before do
      post '/', {auth_token: session.token, from:, to:, synthesizer_id: synthesizer.id.to_s}.to_json
    end
    it 'Returns a 201 (Created) status code' do
      expect(last_response.status).to be 201
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        from:,
        to:,
        synthesizer_id: synthesizer.id.to_s,
        color: 'red'
      )
    end
  end
  describe 'Alternative cases' do
    describe 'The link is created with an alternative color' do
      before do
        post '/', {
          auth_token: session.token,
          from:,
          to:,
          synthesizer_id: synthesizer.id.to_s,
          color: 'yellow'
        }.to_json
      end
      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          from:,
          to:,
          synthesizer_id: synthesizer.id.to_s,
          color: 'yellow'
        )
      end
      describe 'Create link' do
        let!(:link) { Modusynth::Models::Link.first }
        it 'Has the correct color' do
          expect(link.color).to eq 'yellow'
        end
      end
    end
  end
  describe 'Error cases' do
    describe 'The origin port is not given' do
      before do
        post '/', {
          auth_token: session.token,
          to:,
          synthesizer_id: synthesizer.id.to_s,
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'from', message: 'required'
        )
      end
    end
    describe 'The origin port is not found' do
      before do
        post '/', {
          auth_token: session.token,
          to:,
          from: 'unknown',
          synthesizer_id: synthesizer.id.to_s,
        }
      end
      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'from', message: 'unknown'
        )
      end
    end
    describe 'The destination port is not given' do
      before do
        post '/', {
          auth_token: session.token,
          from:,
          synthesizer_id: synthesizer.id.to_s,
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'to', message: 'required'
        )
      end
    end
    describe 'The destination port is not found' do
      before do
        post '/', {
          auth_token: session.token,
          from:,
          to: 'unknown',
          synthesizer_id: synthesizer.id.to_s,
        }
      end
      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'to', message: 'unknown'
        )
      end
    end
    describe 'The synthesizer UUID is not given' do
      before do
        post '/', {
          auth_token: session.token,
          from:,
          to:,
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'synthesizer_id', message: 'required'
        )
      end
    end
    describe 'The synthesizer UUID is not found' do
      before do
        post '/', {
          auth_token: session.token,
          from:,
          to:,
          synthesizer_id: 'unknown'
        }
      end
      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'synthesizer_id', message: 'unknown'
        )
      end
    end
    describe 'Both ports are inputs or outputs' do
      before do
        post '/', {
          auth_token: session.token,
          from:,
          to: from,
          synthesizer_id: synthesizer.id.to_s
        }
      end
      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'directions', message: 'identical'
        )
      end
    end
  end
end
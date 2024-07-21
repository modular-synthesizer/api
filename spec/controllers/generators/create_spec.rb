RSpec.describe 'POST /generators' do
  def app
    Modusynth::Controllers::Generators
  end

  let!(:admin) { create(:random_admin) }
  let!(:session) { create(:session, account: admin) }
  
  describe 'Nominal case' do
    before do
      payload = {
        auth_token: session.token,
        name: 'square_oscillator',
        code: 'return context.createOscillator({type: "square"});'
      }
      post '/', payload.to_json
    end
    it 'Returns a 201 (Created) status code' do
      expect(last_response.status).to be 201
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        name: 'square_oscillator',
        code: 'return context.createOscillator({type: "square"});'
      )
    end
    describe 'Created generator' do
      let!(:generator) { Modusynth::Models::Tools::Generator.first }

      it 'Has the correct name' do
        expect(generator.name).to eq 'square_oscillator'
      end
      it 'Has the correct code content' do
        expect(generator.code).to eq 'return context.createOscillator({type: "square"});'
      end
      it 'Has no parameters' do
        expect(generator.parameters).to eq []
      end
    end
  end

  describe 'Alternative cases' do
    describe 'When creating a generator with only the classname and parameters' do
      before do
        post '/', {
          auth_token: session.token,
          name: 'createGain',
          code: 'GainNode',
          parameters: [ 'gain' ]
        }
      end
      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          name: 'createGain',
          code: 'return new GainNode(context, payload);',
          parameters: [ 'gain' ],
          inputs: 1,
          outputs: 1
        )
      end
      describe 'Created generator' do
        let!(:generator) { Modusynth::Models::Tools::Generator.where(name: 'createGain').first }

        it 'has the correct name' do
          expect(generator.name).to eq 'createGain'
        end
        it 'has the correct code content' do
          expect(generator.code).to eq 'GainNode'
        end
        it 'has the correct parameter name' do
          expect(generator.parameters).to include_json [ 'gain' ]
        end
      end
    end
    describe 'When specifying the number of inputs and outputs' do
      before do
        post '/', {
          auth_token: session.token,
          name: 'createGain',
          code: 'GainNode',
          inputs: 6,
          outputs: 6
        }
      end
      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          name: 'createGain',
          code: 'return new GainNode(context, payload);',
          inputs: 6,
          outputs: 6,
          parameters: []
        )
      end
      describe 'The created generator' do
        let!(:generator) { Modusynth::Models::Tools::Generator.first }

        it 'Has the correct number of inputs' do
          expect(generator.inputs).to be 6
        end
        it 'Has the correct number of outputs' do
          expect(generator.outputs).to be 6
        end
      end
    end
  end

  describe 'Error cases' do
    describe 'When the name is not given' do
      before do
        post '/', { code: 'GainNode', auth_token: session.token }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'name', message: 'required'
        )
      end
    end
    describe 'When the code is not given' do
      before do
        post '/', { name: 'testNode', auth_token: session.token }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'code', message: 'required'
        )
      end
    end
    describe 'When the parameters are not given as an array' do
      before do
        post '/', { name: 'testNode', code: 'GainNode', parameters: 'test', auth_token: session.token }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'parameters', message: 'type'
        )
      end
    end
    describe 'When a parameter is not a string' do
      before do
        post '/', { name: 'testNode', code: 'GainNode', parameters: [{foo: 'bar'}], auth_token: session.token }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'parameters', message: 'type'
        )
      end
    end
  end

  include_examples 'authentication', 'post', '/'
  include_examples 'scopes', 'post', '/'
end
RSpec.describe 'POST /tools/parameters' do
  def app
    Modusynth::Controllers::ToolsResources::Parameters
  end
  
  let!(:account) { create(:random_admin) }
  let!(:session) { create(:session, account:) }
  let!(:category) { create(:dopefun) }
  let!(:tool) { create(:tool, category:, experimental: false) }
  let!(:synthesizer) { Modusynth::Services::Synthesizers.instance.create(account:, name: 'test synth') }
  let!(:mod) { create(:module, tool:, synthesizer:) }

  describe 'Nominal case' do
    before do
      post '/', {
        tool_id: tool.id.to_s,
        auth_token: session.token,
        name: 'custom parameter',
        field: 'gain',
      }
    end
    it 'Returns a 201 (Created) status code' do
      expect(last_response.status).to be 201
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        name: 'custom parameter',
        targets: [],
        field: 'gain',
        minimum: 0,
        maximum: 100,
        default: 50,
        step: 1,
        precision: 0
      )
    end
    it 'Has correctly created a parameter on the tool' do
      expect(tool.parameters.where(name: 'custom parameter').count).to be 1
    end
    describe 'The created parameter' do
      let!(:parameter) { tool.reload && tool.parameters.last }

      it 'Has the correct name' do
        expect(parameter.name).to eq 'custom parameter'
      end
      it 'Has the correct targets' do
        expect(parameter.targets).to eq []
      end
      it 'Has the correct minimum' do
        expect(parameter.minimum).to be 0
      end
      it 'Has the correct maximum' do
        expect(parameter.maximum).to be 100
      end
      it 'Has the correct default' do
        expect(parameter.default).to be 50.0
      end
      it 'Has the correct step' do
        expect(parameter.step).to be 1.0
      end
      it 'Has the correct precision' do
        expect(parameter.precision).to be 0
      end
      it 'Targets the correct field' do
        expect(parameter.field).to eq 'gain'
      end
    end
    describe 'The created instanciation of the parameter in the modules' do
      let!(:parameter) do
        [mod, tool].each(&:reload)
        mod.parameters.last
      end
      it 'Has created the parameter with the correct value' do
        expect(parameter.value).to be 50.0
      end
      it 'Has created the parameter with the correct template' do
        expect(parameter.template.name).to eq 'custom parameter'
      end
    end
  end

  describe 'Alternative cases' do
    describe 'When giving constraints and/or targets' do
      before do
        post '/', {
          tool_id: tool.id.to_s,
          auth_token: session.token,
          name: 'custom parameter',
          field: 'gain',
          minimum: 1,
          maximum: 10,
          default: 5,
          step: 0.1,
          precision: 1,
          targets: ['node1', 'node2']
        }
      end
      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          name: 'custom parameter',
          field: 'gain',
          minimum: 1,
          maximum: 10,
          default: 5,
          step: 0.1,
          precision: 1,
          targets: ['node1', 'node2']
        )
      end
      it 'Has correctly created a parameter on the tool' do
        expect(tool.parameters.where(name: 'custom parameter').count).to be 1
      end
      describe 'The created parameter' do
        let!(:parameter) { tool.reload && tool.parameters.last }
  
        it 'Has the correct name' do
          expect(parameter.name).to eq 'custom parameter'
        end
        it 'Has the correct targets' do
          expect(parameter.targets).to eq ['node1', 'node2']
        end
        it 'Has the correct minimum' do
          expect(parameter.minimum).to be 1
        end
        it 'Has the correct maximum' do
          expect(parameter.maximum).to be 10
        end
        it 'Has the correct default' do
          expect(parameter.default).to be 5.0
        end
        it 'Has the correct step' do
          expect(parameter.step).to be 0.1
        end
        it 'Has the correct precision' do
          expect(parameter.precision).to be 1
        end
        it 'Targets the correct field' do
          expect(parameter.field).to eq 'gain'
        end
      end
    end
  end

  describe 'Error cases' do
    describe 'When the name is not given' do
      before do
        post '/', {
          tool_id: tool.id.to_s,
          auth_token: session.token
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'name', message: 'required'
        )
      end
      it 'Has not created a parameter' do
        expect(tool.parameters.count).to be 0
      end
    end
    describe 'When the field is not given' do
      before do
        post '/', {
          tool_id: tool.id.to_s,
          auth_token: session.token,
          name: 'custom parameter'
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'field', message: 'required'
        )
      end
      it 'Has not created a parameter' do
        expect(tool.parameters.count).to be 0
      end
    end
    describe 'When the boundaries are not in the correct order' do
      before do
        post '/', {
          tool_id: tool.id.to_s,
          auth_token: session.token,
          name: 'custom parameter',
          field: 'gain',
          minimum: 100,
          maximum: 1
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'boundaries', message: 'order'
        )
      end
      it 'Has not created a parameter' do
        expect(tool.parameters.count).to be 0
      end
    end
    describe 'When the default is not between boundaries' do
      before do
        post '/', {
          tool_id: tool.id.to_s,
          auth_token: session.token,
          name: 'custom parameter',
          field: 'gain',
          minimum: 1,
          maximum: 100,
          default: 0
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'default', message: 'value'
        )
      end
      it 'Has not created a parameter' do
        expect(tool.parameters.count).to be 0
      end
    end
  end
end
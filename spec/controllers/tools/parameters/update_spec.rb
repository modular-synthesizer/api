RSpec.describe 'PUT /tools/parameters/:id' do

  def app
    Modusynth::Controllers::ToolsResources::Parameters
  end

  let!(:account) { create(:random_admin) }
  let!(:session) { create(:session, account:) }
  let!(:category) { create(:dopefun) }
  let!(:tool) { create(:tool, category:, name: 'test-tool') }
  let!(:parameter) { create(:parameter, name: 'test-param', field: 'gain', tool:) }
  let!(:synthesizer) { Modusynth::Services::Synthesizers.instance.create(account:, name: 'test synth') }
  let!(:mod) { create(:module, tool:, synthesizer:) }

  describe 'Nominal case' do
    before do
      put "/#{parameter.id.to_s}", { auth_token: session.token }
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        name: 'test-param',
        field: 'gain',
        targets: [],
        minimum: 0,
        maximum: 100,
        default: 50,
        step: 1,
        precision: 0
      )
    end
    describe 'The update parameter' do
      before do
        parameter.reload
      end
      it 'Has not updated the name of the parameter' do
        expect(parameter.name).to eq 'test-param'
      end
      it 'Has not updated the field of the parameter' do
        expect(parameter.field).to eq 'gain'
      end
      it 'Has not updated the minimum of the parameter' do
        expect(parameter.minimum).to eq 0
      end
      it 'Has not updated the maximum of the parameter' do
        expect(parameter.maximum).to eq 100
      end
      it 'Has not updated the step of the parameter' do
        expect(parameter.step).to eq 1
      end
      it 'Has not updated the default of the parameter' do
        expect(parameter.default).to eq 50.0
      end
      it 'Has not updated the precision of the parameter' do
        expect(parameter.precision).to eq 0
      end
      it 'Has not updated the targets of the parameter' do
        expect(parameter.targets).to eq []
      end
    end
  end

  describe 'Alternative cases' do
    describe 'Updates the name' do
      before do
        put "/#{parameter.id.to_s}", {
          auth_token: session.token,
          name: 'another-name'
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          name: 'another-name',
          field: 'gain',
          targets: [],
          minimum: 0,
          maximum: 100,
          default: 50,
          step: 1,
          precision: 0
        )
      end
      it 'Has correctly updated the name' do
        parameter.reload
        expect(parameter.name).to eq 'another-name'
      end
    end
    describe 'Updates the targets' do
      before do
        put "/#{parameter.id.to_s}", {
          auth_token: session.token,
          targets: ['new-target']
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          name: 'test-param',
          targets: ['new-target'],
          field: 'gain',
          minimum: 0,
          maximum: 100,
          default: 50,
          step: 1,
          precision: 0
        )
      end
      it 'Correctly updates the descriptor UUID' do
        parameter.reload
        expect(parameter.targets).to eq ['new-target']
      end
    end
    describe 'Updates the field' do
      before do
        put "/#{parameter.id.to_s}", {
          auth_token: session.token,
          field: 'frequency'
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          name: 'test-param',
          field: 'frequency',
          targets: [],
          minimum: 0,
          maximum: 100,
          default: 50,
          step: 1,
          precision: 0
        )
      end
      it 'Has correctly updated the field' do
        parameter.reload
        expect(parameter.field).to eq 'frequency'
      end
    end
    describe 'Updates the minimum' do
      before do
        put "/#{parameter.id.to_s}", {
          auth_token: session.token,
          minimum: 1
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          name: 'test-param',
          field: 'gain',
          targets: [],
          minimum: 1,
          maximum: 100,
          default: 50,
          step: 1,
          precision: 0
        )
      end
      it 'Has correctly updated the minimum' do
        parameter.reload
        expect(parameter.minimum).to eq 1
      end
    end
    describe 'Updates the maximum' do
      before do
        put "/#{parameter.id.to_s}", {
          auth_token: session.token,
          maximum: 99
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          name: 'test-param',
          field: 'gain',
          targets: [],
          minimum: 0,
          maximum: 99,
          default: 50,
          step: 1,
          precision: 0
        )
      end
      it 'Has correctly updated the maximum' do
        parameter.reload
        expect(parameter.maximum).to eq 99
      end
    end
    describe 'Updates the default' do
      before do
        put "/#{parameter.id.to_s}", {
          auth_token: session.token,
          default: 30
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          name: 'test-param',
          field: 'gain',
          targets: [],
          minimum: 0,
          maximum: 100,
          default: 30,
          step: 1,
          precision: 0
        )
      end
      it 'Has correctly updated the default' do
        parameter.reload
        expect(parameter.default).to eq 30
      end
    end
    describe 'Updates the step' do
      before do
        put "/#{parameter.id.to_s}", {
          auth_token: session.token,
          step: 10
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          name: 'test-param',
          field: 'gain',
          targets: [],
          minimum: 0,
          maximum: 100,
          default: 50,
          step: 10,
          precision: 0
        )
      end
      it 'Has correctly updated the step' do
        parameter.reload
        expect(parameter.step).to eq 10.0
      end
    end
    describe 'Updates the precision' do
      before do
        put "/#{parameter.id.to_s}", {
          auth_token: session.token,
          precision: 1
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          name: 'test-param',
          field: 'gain',
          targets: [],
          minimum: 0,
          maximum: 100,
          default: 50,
          step: 1,
          precision: 1
        )
      end
      it 'Has correctly updated the precision' do
        parameter.reload
        expect(parameter.precision).to eq 1.0
      end
    end
    describe 'The value needs to be clamped when updating the minimum' do
      before do
        put "/#{parameter.id.to_s}", {
          auth_token: session.token,
          minimum: 60,
          default: 60
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          minimum: 60,
        )
      end
       it 'Correctly updates the value in the corresponding modules' do
        mod.reload
        expect(mod.parameters.first.value).to be 60.0
      end
    end
    describe 'The value needs to be clamped when updating the maximum' do
      before do
        put "/#{parameter.id.to_s}", {
          auth_token: session.token,
          maximum: 10,
          default: 10
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          maximum: 10
        )
      end
      it 'Correctly updates the value in the corresponding modules' do
        mod.reload
        expect(mod.parameters.first.value).to be 10.0
      end
    end
  end

  describe 'Error cases' do
    describe 'The name is empty' do
      before do
        put "/#{parameter.id.to_s}", {
          auth_token: session.token,
          name: nil
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
    end
    describe 'The boundaries are not in the correct order when updating the minimum' do
      before do
        put "/#{parameter.id.to_s}", {
          auth_token: session.token,
          minimum: parameter.maximum + 1
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
      it 'Has not updated the minimum' do
        parameter.reload
        expect(parameter.minimum).to be 0
      end
    end
    describe 'The boundaries are not in the correct order when updating the maximum' do
      before do
        put "/#{parameter.id.to_s}", {
          auth_token: session.token,
          maximum: parameter.minimum - 1
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
      it 'Has not updated the minimum' do
        parameter.reload
        expect(parameter.maximum).to be 100
      end
    end
    describe 'The default value is not in boundaries when updating above the maximum' do
      before do
        put "/#{parameter.id.to_s}", {
          auth_token: session.token,
          default: parameter.maximum + 1
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
      it 'Has not updated the default value' do
        parameter.reload
        expect(parameter.default).to be 50.0
      end
    end
    describe 'The default value is not in boundaries when updating below the minimum' do
      before do
        put "/#{parameter.id.to_s}", {
          auth_token: session.token,
          default: parameter.minimum - 1
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
      it 'Has not updated the default value' do
        parameter.reload
        expect(parameter.default).to be 50.0
      end
    end
  end
end
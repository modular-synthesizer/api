RSpec.describe 'DELETE /tools/parameters/:id' do

  def app
    Modusynth::Controllers::ToolsResources::Parameters
  end

  let!(:account) { create(:account, admin: true) }
  let!(:session) { create(:session, account:) }
  let!(:descriptor) { create(:frequency_descriptor) }
  let!(:category) { create(:dopefun) }
  let!(:tool) { create(:tool, category:, name: 'test-tool') }
  let!(:parameter) { create(:parameter, targets: ['test-node'], descriptor:, name: 'test-param', tool:) }
  let!(:synthesizer) { create(:synthesizer, account:) }
  let!(:mod) { create(:module, tool:, synthesizer:) }

  describe 'Nominal case' do
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
        id: parameter.id.to_s,
        name: 'another-name',
        targets: ['test-node'],
      )
    end
    it 'Has correctly updated the name' do
      parameter.reload
      expect(parameter.name).to eq 'another-name'
    end
  end
  describe 'Alternative cases' do
    describe 'Updates the descriptor' do
      let(:other_descriptor) { create(:frequency_descriptor) }

      before do
        put "/#{parameter.id.to_s}", {
          auth_token: session.token,
          descriptorId: other_descriptor.id.to_s
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          descriptorId: other_descriptor.id.to_s
        )
      end
      it 'Correctly updates the descriptor UUID' do
        parameter.reload
        expect(parameter.descriptor.id).to eq other_descriptor.id
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
          targets: ['new-target']
        )
      end
      it 'Correctly updates the descriptor UUID' do
        parameter.reload
        expect(parameter.targets).to eq ['new-target']
      end
    end
    describe 'The value needs to be clamped up' do
      let!(:new_descriptor) { create(:frequency_descriptor, minimum: 500, default: 500) }

      before do
        put "/#{parameter.id.to_s}", {
          auth_token: session.token,
          descriptorId: new_descriptor.id.to_s
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          descriptorId: new_descriptor.id.to_s
        )
      end
      it 'Correctly updates the value in the corresponding modules' do
        mod.reload
        expect(mod.parameters.first.value).to be 500.0
      end
    end
    describe 'The value needs to be clamped down' do
      let!(:new_descriptor) { create(:frequency_descriptor, maximum: 400, default: 400) }

      before do
        put "/#{parameter.id.to_s}", {
          auth_token: session.token,
          descriptorId: new_descriptor.id.to_s
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          descriptorId: new_descriptor.id.to_s
        )
      end
      it 'Correctly updates the value in the corresponding modules' do
        mod.reload
        expect(mod.parameters.first.value).to be 400.0
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
    describe 'The descriptor is not found' do
      before do
        put "/#{parameter.id.to_s}", {
          auth_token: session.token,
          descriptorId: 'unknown'
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'descriptorId', message: 'unknown'
        )
      end
    end
  end
end
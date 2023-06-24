RSpec.describe 'PUT /tools/controls/:id' do

  def app
    Modusynth::Controllers::ToolsResources::Controls
  end
  
  let!(:account) { create(:account, admin: true) }
  let!(:session) { create(:session, account:) }
  let!(:category) { create(:dopefun) }
  let!(:tool) { create(:VCA, category:, experimental: false) }
  let!(:control) { tool.controls.first }

  describe 'Nominal case' do
    before do
      put "/#{control.id.to_s}", { auth_token: session.token, component: 'OtherComponent' }
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        id: control.id.to_s,
        component: 'OtherComponent'
      )
    end
    it 'Has updated the component of the control' do
      control.reload
      expect(control.component).to eq 'OtherComponent'
    end
  end
  describe 'Alternative case' do
    describe 'When the payload is updated' do
      before do
        put "/#{control.id.to_s}", { auth_token: session.token, payload: {bar: 'baz'} }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: control.id.to_s,
          component: 'Knob',
          payload: {bar: 'baz'}
        )
      end
      it 'Has updated the payload of the control' do
        control.reload
        expect(control.payload).to eq({'bar' => 'baz'})
      end
    end
  end
  describe 'Error cases' do
    describe 'When the UUID is not found' do
      before do
        put '/unknown', { auth_token: session.token }
      end
      it 'Returns a 404 (Not Found status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'id', message: 'unknown'
        )
      end
      it 'Has not updated the component of the control' do
        expect(control.component).to eq 'Knob'
      end
      it 'Has not updated the payload of the control' do
        expect(control.payload).to eq({x: 0, y: 100, target: 'gainparam'})
      end
    end
    describe 'When the component is not given' do
      before do
        put "/#{control.id.to_s}", { auth_token: session.token, component: nil }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'component', message: 'required'
        )
      end
      it 'Has not updated the component of the control' do
        expect(control.component).to eq 'Knob'
      end
      it 'Has not updated the payload of the control' do
        expect(control.payload).to eq({x: 0, y: 100, target: 'gainparam'})
      end
    end
  end
end
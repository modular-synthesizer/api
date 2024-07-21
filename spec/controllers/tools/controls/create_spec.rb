RSpec.describe 'POST /tools/controls' do
  def app
    Modusynth::Controllers::ToolsResources::Controls
  end
  
  let!(:account) { create(:random_admin) }
  let!(:session) { create(:session, account:) }
  let!(:category) { create(:dopefun) }
  let!(:tool) { create(:VCA, category:, experimental: false) }

  describe 'Nominal case' do
    before do
      post '/', {
        auth_token: session.token,
        tool_id: tool.id.to_s,
        component: 'TestComponent',
        payload: {foo: 'bar'}
      }
    end
    it 'Returns a 201 (Created) status code' do
      expect(last_response.status).to be 201
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        component: 'TestComponent',
        payload: {foo: 'bar'}
      )
    end
    describe 'The created control' do
      let!(:control) { tool.reload; tool.controls.last }

      it 'Has created a control with the correct component' do
        expect(control.component).to eq 'TestComponent'
      end
      it 'Has created a control with the correct payload' do
        expect(control.payload).to eq({'foo' => 'bar'})
      end
    end
  end
  describe 'Alternative cases' do
    describe 'When the payload is not given' do
      before do
        post '/', {
          auth_token: session.token,
          tool_id: tool.id.to_s,
          component: 'TestComponent'
        }
      end
      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          component: 'TestComponent',
          payload: {}
        )
      end
      describe 'The created control' do
        let!(:control) { tool.reload; tool.controls.last }
  
        it 'Has created a control with the correct component' do
          expect(control.component).to eq 'TestComponent'
        end
        it 'Has created a control with the correct payload' do
          expect(control.payload).to eq({})
        end
      end
    end
  end
  describe 'Error cases' do
    describe 'When the component is not given' do
      before do
        post '/', {
          auth_token: session.token,
          tool_id: tool.id.to_s,
          payload: {foo: 'bar'}
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'component', message: 'required'
        )
      end
      it 'Has not created a control' do
        expect(tool.controls.count).to be 1
      end
    end
    describe 'When the component has an incorrect format' do
      before do
        post '/', {
          auth_token: session.token,
          tool_id: tool.id.to_s,
          component: 'wrong format'
        }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'component', message: 'format'
        )
      end
      it 'Has not created a control' do
        expect(tool.controls.count).to be 1
      end
    end
  end
end
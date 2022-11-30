RSpec.describe 'POST /generators' do
  def app
    Modusynth::Controllers::Generators
  end

  let!(:admin) { create(:random_admin) }
  let!(:admin_session) { create(:session, account: admin) }
  
  describe 'Nominal case' do
    before do
      payload = {
        auth_token: admin_session.token,
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
    end
  end

  include_examples 'admin', 'post', '/'
end
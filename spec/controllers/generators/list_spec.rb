RSpec.describe 'GET /generators' do
  def app
    Modusynth::Controllers::Generators
  end

  let!(:account) { create(:account, admin: true) }
  let!(:session) { create(:session, account: account) }

  describe 'Nominal case' do
    let!(:generator) { create(:generator) }

    before do
      get '/', {auth_token: session.token}
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json([
        {
          id: generator.id.to_s,
          name: 'test_generator',
          code: 'test code to execute();',
          inputs: 1,
          outputs: 1
        }
      ])
    end
  end
  describe 'Empty list' do
    before do
      get '/', {auth_token: session.token}
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json([])
    end
  end

  include_examples 'authentication', 'get', '/'
end
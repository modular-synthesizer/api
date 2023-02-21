RSpec.describe 'POST /applications' do

  def app
    Modusynth::Controllers::Applications
  end

  let!(:account) { create(:babausse, admin: true) }
  let!(:session) { create(:session, account:) }

  describe 'Nominal case' do
    before do
      post '/', {
        auth_token: session.token,
        name: 'Application Name'
      }.to_json
    end
    it 'Returns a 201 (Created) status code' do
      expect(last_response.status).to be 201
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        name: 'Application Name'
      )
    end
    describe 'The created application' do
      let!(:application) { Modusynth::Models::OAuth::Application.first }

      it 'Has the correct name' do
        expect(application.name).to eq 'Application Name'
      end
      it 'Has a public key with the correct length' do
        expect(application.public_key.length).to be 32
      end
      it 'Has a private key with the correct length' do
        expect(application.private_key.length).to be 128
      end
    end
  end
  describe 'Error cases' do
    describe 'When the name is not given' do
      before do
        post '/', {
          auth_token: session.token,
        }.to_json
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
    describe 'When the name is given as nil' do
      before do
        post '/', {
          auth_token: session.token,
          name: nil
        }.to_json
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
    describe 'When the name is too short' do
      before do
        post '/', {
          auth_token: session.token,
          name: 'App'
        }.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'name', message: 'length'
        )
      end
    end
    describe 'When the name is already taken' do
      let!(:conflict) { create(:application, account:, name: 'Conflicting') }
      before do
        post '/', {
          auth_token: session.token,
          name: 'Conflicting'
        }.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'name', message: 'uniq'
        )
      end
    end
  end
end
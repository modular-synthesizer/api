RSpec.describe 'POST /scopes' do
  def app
    Modusynth::Controllers::Rights.new
  end

  let!(:account) { create(:random_admin) }
  let!(:session) { create(:session, account: account) }

  describe 'Nominal case' do
    before do
      post '/', {auth_token: session.token, label: 'Test::Scopes'}.to_json
    end
    it 'Returns a 201 (Created) status code' do
      expect(last_response.status).to be 201
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(label: 'Test::Scopes', groups: [])
    end
    describe 'The created scope' do
      let!(:creation) { Modusynth::Models::Permissions::Right.last }
      
      it 'Has the correct label' do
        expect(creation.label).to eq 'Test::Scopes'
      end
      it 'Has an empty groups list' do
        expect(creation.groups).to eq []
      end
    end
  end
  describe 'Error cases' do
    describe 'Label not given' do
      before do
        post '/', {auth_token: session.token}.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'label', message: 'required'
        )
      end
    end
    describe 'Label given as nil' do
      before do
        post '/', {auth_token: session.token, label: nil}.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'label', message: 'required'
        )
      end
    end
    describe 'Label too short' do
      before do
        post '/', {auth_token: session.token, label: 'a::b'}.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'label', message: 'minlength'
        )
      end
    end
    describe 'Label with an incorrect format' do
      before do
        post '/', {auth_token: session.token, label: 'test-format'}.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'label', message: 'format'
        )
      end
    end
    describe 'Label already in use' do
      before do
        create(:scope, label: 'Test::Duplicate')
        post '/', {auth_token: session.token, label: 'Test::Duplicate'}.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'label', message: 'uniq'
        )
      end
    end
  end

  include_examples 'authentication', 'post', '/'
  include_examples 'scopes', 'post', '/'
end
RSpec.describe Modusynth::Controllers::Tools do
  def app
    Modusynth::Controllers::Tools
  end

  describe 'GET /' do
    let!(:account) { create(:account, admin: false) }
    let!(:session) { create(:session, account: account) }

    describe 'empty list' do
      before { get '/', {auth_token: session.token} }

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'returns an empty list when nothing has been created' do
        expect(last_response.body).to include_json({})
      end
    end

    describe 'not empty list' do
      let!(:dopefun) { create(:dopefun) }
      let!(:tool) { create(:VCA, category: dopefun, experimental: false) }
      before { get '/', {auth_token: session.token} }
      
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(JSON.parse(last_response.body)).to include_json([
          {'id' => tool.id.to_s, 'name' => 'VCA', 'slots' => 3}
        ])
      end
    end

    describe 'list with experimental tools' do
      let!(:dopefun) { create(:dopefun) }
      let!(:experimental_tool) { create(:VCA, category: dopefun) }
      let!(:tool) { create(:VCA, category: dopefun, experimental: false) }

      describe 'When requesting with a non admin account' do
        before do
          get '/', { auth_token: session.token }
        end
        it 'Returns a 200 (OK) status code' do
          expect(last_response.status).to be 200
        end
        it 'Returns the correct number of items' do
          expect(JSON.parse(last_response.body).count).to be 1
        end
        it 'Returns only the non-experimental ones' do
          expect(JSON.parse(last_response.body).first['id']).to eq tool.id.to_s
        end
      end
      describe 'When requesting with an admin account' do
        let!(:admin) { create(:account, admin: true) }
        let!(:admin_session) { create(:session, account: admin) }

        before do
          get '/', { auth_token: admin_session.token }
        end
        it 'Returns a 200 (OK) status code' do
          expect(last_response.status).to be 200
        end
        it 'Returns all the records' do
          expect(JSON.parse(last_response.body).count).to be 2
        end
      end
    end

    include_examples 'authentication', 'get', '/'
  end
end
RSpec.describe 'POST /categories' do
  def app
    Modusynth::Controllers::Categories
  end

  let!(:admin) { create(:random_admin) }
  let!(:admin_session) { create(:session, account: admin) }
  
  describe 'Nominal case' do
    before do
      post '/', {name: 'testCategory', auth_token: admin_session.token}.to_json
    end

    it 'Returns a 201 (Created) status code' do
      expect(last_response.status).to be 201
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        id: have_attributes(size: 24),
        name: 'testCategory'
    )
    end
    describe 'The created category' do
      let!(:category) { Modusynth::Models::Category.first }

      it 'Has the correct name' do
        expect(category.name).to eq 'testCategory'
      end
      it 'Has no tools at creation' do
        expect(category.tools.count).to be 0
      end
    end
  end

  describe 'Error cases' do
    describe 'The name is not given' do
      before do
        post '/', {auth_token: admin_session.token}.to_json
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
    describe 'The name is not at least one character long' do
      before do
        post '/', {name: 'c', auth_token: admin_session.token}.to_json
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
    describe 'The name is already used in another category' do
      before do
        post '/', {name: 'testCategory', auth_token: admin_session.token}.to_json
        post '/', {name: 'testCategory', auth_token: admin_session.token}.to_json
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
    describe 'The name has a bad format' do
      before do
        post '/', {name: 'test category', auth_token: admin_session.token}.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'name', message: 'format'
        )
      end
    end
  end

  include_examples 'admin', 'post', '/'
end
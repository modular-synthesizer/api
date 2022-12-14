describe 'POST /groups' do
  def app
    Modusynth::Controllers::Groups
  end

  let!(:account) { create(:account, admin: true) }
  let!(:session) { create(:session, account: account) }

  describe 'Nominal case' do
    before do
      payload = {
        slug: 'custom-slug',
        auth_token: session.token
      }
      post '/', payload.to_json
    end
    it 'Returns a 201 (Created) status code' do
      expect(last_response.status).to be 201
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        slug: 'custom-slug'
      )
    end
    describe 'Created group' do
      let!(:group_model) { Modusynth::Models::Permissions::Group }
      
      it 'Has created only one group' do
        expect(group_model.all.count).to be 1
      end
      it 'Has created a group with the correct slug' do
        expect(group_model.first.slug).to eq 'custom-slug'
      end
    end
  end

  describe 'Error cases' do
    describe 'The slug is not given' do
      before do
        post '/', { auth_token: session.token }.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'slug', message: 'required'
        )
      end
    end
    describe 'The slug is empty' do
      before do
        post '/', { slug: '', auth_token: session.token }.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'slug', message: 'required'
        )
      end
    end
    describe 'The slug does not have the correct length' do
      before do
        post '/', { slug: 'foo', auth_token: session.token }.to_json
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'slug', message: 'minlength'
        )
      end
      describe 'The slug does not have the correct format' do
        before do
          post '/', { slug: '12345__', auth_token: session.token }.to_json
        end
        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            key: 'slug', message: 'format'
          )
        end
      end
    end
  end

  include_examples 'admin', 'post', '/'
end
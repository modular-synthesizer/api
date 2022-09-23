RSpec.describe Modusynth::Controllers::Categories do
  def app
    Modusynth::Controllers::Categories
  end

  describe 'Nominal case' do
    before do
      post '/', {name: 'testCategory'}.to_json
      get '/'
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json([
        {
          id: have_attributes(size: 24),
          name: 'testCategory'
        }
      ])
    end
  end
  describe 'Alternative cases' do
    describe 'Empty list' do
      before do
        get '/'
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json([])
      end
    end
  end
end
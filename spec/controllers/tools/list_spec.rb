RSpec.describe Modusynth::Controllers::Tools do
  def app
    Modusynth::Controllers::Tools
  end

  describe 'GET /' do
    describe 'empty list' do
      before { get '/' }

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'returns an empty list when nothing has been created' do
        expect(last_response.body).to include_json({tools: []})
      end
    end

    describe 'not empty list' do
      let!(:tool) { create(:VCA) }
      before { get '/' }
      
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(JSON.parse(last_response.body)).to eq({
          'tools' => [
            {'id' => tool.id.to_s, 'name' => 'VCA'}
          ]
        })
      end
    end
  end
end
RSpec.shared_examples 'authentication::synthesizers' do |verb, path, ownership: false|

  describe 'Authentication errors' do
    id = BSON::ObjectId.new
    # This synthesizer is used in the authentication tests only
    let!(:synthesizer) { create(:synthesizer, id: id, account: babausse) }

    include_examples 'authentication', 'get', "/#{id}", ownership: true
  end
end
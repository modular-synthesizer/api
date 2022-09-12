RSpec.describe Modusynth::Controllers::Tools do
  def app
    Modusynth::Controllers::Tools
  end

  describe 'GET /' do
    describe 'empty list' do
      before { get '/' }

      it 'returns an empty list when nothing has been created' do
        expect(last_response.body).to include_json({tools: []})
      end
    end
  end

  describe 'POST /' do

    def create(body = {})
      post '/', body.to_json, 'CONTENT_TYPE' => 'application/json'
    end

    describe 'Nominal case' do
      before { create({name: 'test', slots: 10}) }

      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: Modusynth::Models::Tool.first.id.to_s,
          name: 'test',
          slots: 10,
          innerNodes: []
        )
      end
      describe 'Created tool' do
        let!(:tool) { Modusynth::Models::Tool.first }

        it 'Has the correct name' do
          expect(tool.name).to eq 'test'
        end
        it 'has the correct number of slots' do
          expect(tool.slots).to be 10
        end
        it 'has no inner nodes' do
          expect(tool.inner_nodes).to eq []
        end
      end
    end

    describe 'Alternative cases' do
      describe 'Tool with inner nodes' do
        before { create({name: 'test', slots: 10, inner_nodes: [{ name: 'foo', factory: 'bar' }]}) }

        it 'Returns a 201 (Created) status code' do
          expect(last_response.status).to be 201
        end
        it 'Returns the correct body' do
          creation = Modusynth::Models::Tool.first
          expect(last_response.body).to include_json(
            id: creation.id.to_s,
            name: 'test',
            slots: 10,
            innerNodes: [{
              id: creation.inner_nodes.first.id.to_s,
              name: 'foo',
              factory: 'bar'
            }]
          )
        end

        describe 'Created inner nodes' do
          let!(:tool) { Modusynth::Models::Tool.first }
          let!(:node) { tool.inner_nodes.first }

          it 'Has created exactly one inner node' do
            expect(tool.inner_nodes.size).to be 1
          end
          it 'Has creatd a node with the correct name' do
            expect(node.name).to eq 'foo'
          end
          it 'Has created a node wih the correct factory' do
            expect(node.factory).to eq 'bar'
          end
        end
      end
    end

    describe 'No name given' do
      before { create }

      it 'Returns a 400 (Bad Request) error code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct error body' do
        expect(last_response.body).to include_json({key: 'name', message: 'required'})
      end
    end

    describe 'Name too short' do
      before { create({name: 'a'}) }

      it 'Returns a 400 (Bad Request) error code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct error body' do
        expect(last_response.body).to include_json({key: 'name', message: 'length'})
      end
    end

    describe 'Slots not given' do
      before { create({name: 'test'}) }

      it 'Returns a 400 (Bad Request) error code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct error body' do
        expect(last_response.body).to include_json({key: 'slots', message: 'required'})
      end
    end

    describe 'Slots given with negative value' do
      before { create({name: 'test', slots: -1}) }

      it 'Returns a 400 (Bad Request) error code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct error body' do
        expect(last_response.body).to include_json({key: 'slots', message: 'value'})
      end
    end

    describe 'Slots given with zero as value' do
      before { create({name: 'test', slots: 0}) }

      it 'Returns a 400 (Bad Request) error code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct error body' do
        expect(last_response.body).to include_json({key: 'slots', message: 'value'})
      end
    end

    describe 'Inner nodes errors' do

      def create_with_node(payload = {})
        create({name: 'test', slots: 10, inner_nodes: [payload]})
      end

      describe 'name not given' do
        before { create_with_node() }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'inner_nodes[0].name', message: 'required'})
        end
      end

      describe 'name too short' do
        before { create_with_node({name: 'a'}) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'inner_nodes[0].name', message: 'length'})
        end
      end

      describe 'factory not given' do
        before { create_with_node({name: 'test'}) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'inner_nodes[0].factory', message: 'required'})
        end
      end

      describe 'factory not given' do
        before { create_with_node({name: 'test', factory: 'a'}) }

        it 'Returns a 400 (Bad Request) error code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct error body' do
          expect(last_response.body).to include_json({key: 'inner_nodes[0].factory', message: 'length'})
        end
      end
    end
  end
end
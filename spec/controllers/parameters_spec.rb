RSpec.describe Modusynth::Controllers::Parameters do
  def app
    Modusynth::Controllers::Parameters
  end

  describe 'GET /' do
    describe 'Empty list' do
      before { get '/' }

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(parameters: [])
      end
    end
    describe 'List with items' do
      let!(:param) { create(:frequency) }

      before { get '/' }

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          'parameters' => [
            {
              'id': Modusynth::Models::Tools::Descriptor.first.id.to_s,
              'name' => 'frequency',
              'value' => 440,
              'constraints' => {
                'minimum' => 20,
                'maximum' => 2020,
                'step' => 1.0,
                'precision' => 0,
              }
            }
          ]
        })
      end
    end
  end

  describe 'POST /' do
    describe 'Nominal case' do
      before do
        post '/', {
          name: 'foo',
          minimum: 0,
          maximum: 10,
          default: 0,
          step: 1,
          precision: 0
        }.to_json
      end
      it 'Returns a 201 (Created) status code' do

      end
      it 'Returns the correct body' do

      end
      describe 'Created parameter' do
        let!(:param) { Modusynth::Models::Tools::Descriptor.first }
        it 'Has the correct name' do
          expect(param.name).to eq 'foo'
        end
        it 'Has the correct minimum' do
          expect(param.minimum).to be 0
        end
        it 'Has the correct maximum' do
          expect(param.maximum).to be 10
        end
        it 'Has the correct step' do
          expect(param.step).to be 1.0
        end
        it 'Has the correct precision' do
          expect(param.precision).to be 0
        end
        it 'Has the correct default' do
          expect(param.default).to be 0
        end
      end
    end
    describe 'Error cases' do
      describe 'The name is not given' do
        before { post '/' }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json({
            key: 'name', message: 'required'
          })
        end
      end
      describe 'The name is too short' do
        before { post '/', {name: 'a'}.to_json }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json({
            key: 'name', message: 'length'
          })
        end
      end

      describe  'The minimum is not given' do
        before { post '/', {name: 'foo'}.to_json }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json({
            key: 'minimum', message: 'required'
          })
        end
      end

      describe 'The maximum is not given' do
        before { post '/', {name: 'foo', minimum: 0}.to_json }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json({
            key: 'maximum', message: 'required'
          })
        end
      end

      describe 'The step attribute is not given' do
        before { post '/', {name: 'foo', minimum: 0, maximum: 10}.to_json }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json({
            key: 'step', message: 'required'
          })
        end
      end

      describe 'The precision is not given' do
        before { post '/', {name: 'foo', minimum: 0, maximum: 10, step: 1}.to_json }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json({
            key: 'precision', message: 'required'
          })
        end
      end

      describe 'The default is not given' do
        before { post '/', {name: 'foo', minimum: 0, maximum: 10, step: 1, precision: 0}.to_json }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json({
            key: 'default', message: 'required'
          })
        end
      end

      describe 'The default is above the maximum' do
        before { post '/', {name: 'foo', minimum: 0, maximum: 10, step: 1, precision: 0, default: 11}.to_json }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json({
            key: 'default', message: 'value'
          })
        end
      end

      describe 'The minimum is below the minimum' do
        before { post '/', {name: 'foo', minimum: 1, maximum: 10, step: 1, precision: 0, default: 0}.to_json }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json({
            key: 'default', message: 'value'
          })
        end
      end

      describe 'The step attribute is too broad for the boundaries' do
        before { post '/', {name: 'foo', minimum: 0, maximum: 1, step: 1, precision: 0, default: 0}.to_json }

        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json({
            key: 'step', message: 'broad'
          })
        end
      end
    end
  end
end
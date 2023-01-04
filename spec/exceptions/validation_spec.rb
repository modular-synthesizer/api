RSpec.describe 'Custom validation exception' do
  describe :messages do
    let!(:payload) do
      {foo: 'bar', baz: 'more complex message'}
    end
    describe 'With a given prefix' do
      let!(:exception) { Modusynth::Exceptions::Validation.new(messages: payload, prefix: 'pretest') }

      it 'Returns the correct messages' do
        expect(exception.messages).to eq({:'pretest.foo' => 'bar', :'pretest.baz' => 'more complex message'})
      end
    end
    describe 'Without prefix' do
      let!(:exception) { Modusynth::Exceptions::Validation.new(messages: payload) }

      it 'Returns the same messages' do
        expect(exception.messages).to eq payload
      end
    end
  end
end
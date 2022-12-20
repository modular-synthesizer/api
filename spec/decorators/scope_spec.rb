RSpec.describe Modusynth::Decorators::Group do
  let!(:decorator) { Modusynth::Decorators::Scope }
  let!(:scope_model) { Modusynth::Models::Permissions::Scope }
  let!(:group_model) { Modusynth::Models::Permissions::Group }
  let!(:groups) {
    [
      group_model.create(slug: 'b-grade-group'),
      group_model.create(slug: 'a-grade-group')
    ]
  }
  let!(:scope) { scope_model.create(label: 'Decorator::Test', groups: groups) }

  it 'Decorates the model correctly as a hash' do
    expect(decorator.new(scope).to_h).to eq({
      id: scope.id.to_s,
      label: 'Decorator::Test',
      groups: [
        {id: groups.last.id.to_s, slug: 'a-grade-group'},
        {id: groups.first.id.to_s, slug: 'b-grade-group'}
      ]
    })
  end
end
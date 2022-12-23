RSpec.describe Modusynth::Decorators::Group do
  let!(:decorator) { Modusynth::Decorators::Group }
  let!(:scope_model) { Modusynth::Models::Permissions::Right }
  let!(:group_model) { Modusynth::Models::Permissions::Group }
  let!(:scopes) {
    [
      scope_model.create(label: 'Custom::Second'),
      scope_model.create(label: 'Custom::First')
    ]
  }
  let!(:group) { group_model.create(slug: 'custom-slug', scopes: scopes) }

  it 'Decorates the model correctly as a hash' do
    expect(decorator.new(group).to_h).to eq({
      id: group.id.to_s,
      slug: 'custom-slug',
      scopes: [
        {id: scopes.last.id.to_s, label: 'Custom::First'},
        {id: scopes.first.id.to_s, label: 'Custom::Second'}
      ]
    })
  end
end
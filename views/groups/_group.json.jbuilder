json.id group.id.to_s
json.(group, :slug, :is_default)
json.scopes do
  json.partial! 'groups/scope', collection: group.scopes.sort_by(&:label), as: :scope
end
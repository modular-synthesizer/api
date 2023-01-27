json.id right.id.to_s
json.label right.label
json.groups do
  json.partial! 'rights/group', collection: right.groups, as: :group
end
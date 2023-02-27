json.id account.id.to_s
json.(account, :email, :username)
json.groups do
  json.partial! 'groups/group', collection: account.all_groups, as: :group
end
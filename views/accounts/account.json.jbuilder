json.id account.id.to_s
json.(account, :email, :username, :sample_rate)
json.groups do
  json.partial! 'groups/group', collection: account.all_groups, as: :group
end
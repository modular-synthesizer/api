json.id membership.synthesizer.id.to_s
json.call(membership.synthesizer, :name, :voices, :sample_rate)
json.call(membership, :x, :y, :scale)
json.members do
  json.array! membership.synthesizer.memberships do |m|
    json.id m.id.to_s
    json.account_id m.account.id.to_s
    json.username m.account.username
    json.type m.type.to_s
  end
end

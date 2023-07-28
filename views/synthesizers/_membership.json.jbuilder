json.id membership.id.to_s
json.type membership.enum_type
json.(membership, :x, :y, :scale)
json.synthesizer do
    json.id membership.synthesizer.id.to_s
    json.name membership.synthesizer.name
end
json.account do
    json.id membership.account.id.to_s
    json.username membership.account.username
end
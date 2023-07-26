json.id membership.synthesizer.id.to_s
json.(membership.synthesizer, :name, :slots, :racks, :voices)
json.(membership, :x, :y, :scale)
json.creator do
  json.username membership.synthesizer.creator.account.username
  json.id membership.synthesizer.creator.account.id.to_s
end
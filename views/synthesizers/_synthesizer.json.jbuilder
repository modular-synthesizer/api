json.id synthesizer.id.to_s
json.(synthesizer, :name, :slots, :racks, :x, :y, :scale)
json.creator do
  json.username synthesizer.account.username
  json.id synthesizer.account.id.to_s
end
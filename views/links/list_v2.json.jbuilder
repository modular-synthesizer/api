json.array! links do |link|
  json.id link.id.to_s
  json.color link.color
  json.from do
    json.port link.from.descriptor.name.to_s
    json.module link.from.module.id.to_s
  end
  json.to do
    json.port link.to.descriptor.name.to_s
    json.module link.to.module.id.to_s
  end
end
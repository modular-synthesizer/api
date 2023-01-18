json.id link.id.to_s
json.from do
  json.node link.from.node
  json.index link.from.index
end
json.to do
  json.to link.from.node
  json.to link.from.index
end
json.id link.id.to_s
json.from do
  json.node link.from.node
  json.index link.from.index
end
json.to do
  json.node link.to.node
  json.index link.to.index
end
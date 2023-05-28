json.id tool.id.to_s
json.(tool, :name, :slots, :experimental)
json.ports do
  json.partial! 'tools/port', collection: tool.ports, as: :port
end
json.category do
  json.partial! 'tools/category', category: tool.category
end
json.controls do
  json.partial! 'tools/control', collection: tool.controls, as: :control
end
json.nodes do
  json.partial! 'tools/node', collection: tool.inner_nodes, as: :node
end
json.parameters do
  json.partial! 'tools/parameter', collection: tool.parameters, as: :parameter
end
json.links do
  json.partial! 'tools/link', collection: tool.inner_links, as: :link
end
json.id mod.id.to_s
json.(mod, :slot, :rack)
json.(mod.tool, :slots)
json.type mod.tool.name
json.category (mod.tool.category.nil? ? 'tools' : mod.tool.category.name)
json.nodes do
  json.partial! 'tools/node', collection: mod.tool.inner_nodes, as: :node
end
json.links do
  json.partial! 'tools/link', collection: mod.tool.inner_links, as: :link
end
json.parameters do
  json.partial! 'modules/parameter', collection: mod.parameters, as: :parameter
end
json.ports do
  json.partial! 'modules/port', collection: mod.ports, as: :port
end
json.controls do
  json.partial! 'modules/control', collection: mod.tool.controls, as: :control
end
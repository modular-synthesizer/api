json.partial! 'blueprints/blueprint', blueprint: blueprint
json.ports do
  json.partial! 'blueprints/port', collection: blueprint.ports, as: :port
end
json.controls do
  json.partial! 'blueprints/control', collection: blueprint.controls, as: :control
end
json.nodes do
  json.partial! 'blueprints/node', collection: blueprint.inner_nodes, as: :node
end
json.parameters do
  json.partial! 'blueprints/parameter', collection: blueprint.parameters, as: :parameter
end
json.links do
  json.partial! 'blueprints/link', collection: blueprint.inner_links, as: :link
end
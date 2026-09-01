json.id mod.id.to_s
json.(mod, :slot, :rack)
json.(mod.blueprint, :slots)
json.synthesizer_id mod.synthesizer.id.to_s
json.voices mod.synthesizer.voices
json.type mod.blueprint.name
json.category (mod.blueprint.category.nil? ? 'blueprints' : mod.blueprint.category.name)
json.nodes do
  json.partial! 'blueprints/node', collection: mod.blueprint.inner_nodes, as: :node
end
json.links do
  json.partial! 'blueprints/link', collection: mod.blueprint.inner_links, as: :link
end
json.parameters do
  json.partial! 'modules/parameter', collection: mod.parameters, as: :parameter
end
json.ports do
  json.partial! 'modules/port', collection: mod.ports, as: :port
end
json.controls do
  json.partial! 'modules/control', collection: mod.blueprint.controls, as: :control
end
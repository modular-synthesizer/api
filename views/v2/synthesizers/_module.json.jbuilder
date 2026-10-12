# frozen_string_literal: true

json.name audio_module.blueprint.name
json.controls do
  json.partial! 'v2/synthesizers/controls.json', collection: audio_module.controls, as: :control, audio_module:
end
json.nodes do
  json.partial! 'v2/synthesizers/nodes.json', collection: audio_module.blueprint.inner_nodes, as: :node
end

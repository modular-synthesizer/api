# frozen_string_literal: true

json.modules do
  json.partial! 'v2/synthesizers/module', collection: synthesizer.modules, as: :audio_module
end
json.cables do
  json.partial! 'v2/synthesizers/cable', collection: synthesizer.links, as: :cable
end
json.call(synthesizer, :name, :voices)
json.call(membership, :x, :y)

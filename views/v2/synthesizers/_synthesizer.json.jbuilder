# frozen_string_literal: true

json.modules do
  json.partial! 'v2/synthesizers/module', collection: membership.synthesizer.modules, as: :audio_module
end
json.cables do
  json.partial! 'v2/synthesizers/cable', collection: membership.synthesizer.links, as: :cable
end
json.call(membership.synthesizer, :name, :voices)
json.call(membership, :x, :y)

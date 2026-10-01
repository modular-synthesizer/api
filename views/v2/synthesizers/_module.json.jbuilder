# frozen_string_literal: true

json.name audio_module.blueprint.name
json.controls do
  json.partial! 'v2/synthesizers/controls', collection: audio_module.controls, as: :control
end

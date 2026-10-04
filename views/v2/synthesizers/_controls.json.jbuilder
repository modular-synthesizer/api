if control.component == 'Port'
  port = audio_module.ports.find do |port|
    port.name == control.payload['target']
  end
  json.partial! 'v2/synthesizers/controls/port.json', control:, port: 
end
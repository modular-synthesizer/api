json.call(control, :component)
json.id port.id.to_s
json.call(control.payload, :x, :y, :label)
json.target port.target
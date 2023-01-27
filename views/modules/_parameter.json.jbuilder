json.id parameter.id.to_s
json.(parameter, :value)
json.(parameter.parameter, :name, :targets)
json.field parameter.parameter.descriptor.field
json.input do
  json.id parameter.parameter.id.to_s
end
json.constraints do
  json.(parameter.parameter.descriptor, :minimum, :maximum, :step, :precision)
end
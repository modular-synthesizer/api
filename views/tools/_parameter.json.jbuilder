json.id parameter.id.to_s
json.descriptorId parameter.descriptor.id.to_s
json.value parameter.descriptor.default
json.(parameter, :name, :targets)
json.constraints do
  json.(parameter.descriptor, :minimum, :maximum, :step, :precision)
end
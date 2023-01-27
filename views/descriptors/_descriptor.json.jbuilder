json.id descriptor.id.to_s
json.name descriptor.name
json.value descriptor.default
json.constraints do
  json.(descriptor, :minimum, :maximum, :step, :precision)
end
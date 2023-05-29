json.array! processors do |processor|
  json.id processor.id.to_s
  json.(processor, :registration_name)
end
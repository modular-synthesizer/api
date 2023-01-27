json.parameters do
  json.partial! 'descriptors/descriptor', collection: descriptors, as: :descriptor
end
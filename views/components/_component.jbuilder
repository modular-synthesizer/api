# frozen_string_literal: true

json.call(:component_name)
json.variables do
  json.partial! 'tools/attribute', collection: component.variables, as: :variable
end

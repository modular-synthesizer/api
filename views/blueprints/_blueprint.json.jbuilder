json.id blueprint.id.to_s
json.(blueprint, :name, :slots, :experimental, :x, :y, :scale)
json.category do
  json.partial! 'blueprints/category', category: blueprint.category
end
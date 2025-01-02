json.id tool.id.to_s
json.(tool, :name, :slots, :experimental, :x, :y)
json.category do
  json.partial! 'tools/category', category: tool.category
end
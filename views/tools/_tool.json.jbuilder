json.id tool.id.to_s
json.(tool, :name, :slots, :experimental)
json.category do
  json.partial! 'tools/category', category: tool.category
end
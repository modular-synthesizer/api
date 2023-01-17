json.array! generators do |g|
  json.id g.id.to_s
  json.(g, :name, :code)
end
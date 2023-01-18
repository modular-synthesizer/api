json.id link.id.to_s
json.from do
  json.partial! :link_end, link_end: link.from
end
json.to do
  json.partial! :link_end, link_end: link.to
end
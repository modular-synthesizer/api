json.id processor.id.to_s
json.creator do
  json.id processor.account.id.to_s
  json.username processor.account.username
end
json.(processor, :url, :public)
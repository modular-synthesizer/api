json.created_at session.created_at.iso8601(0)
json.account_id session.account.id.to_s
json.(session, :token, :duration)
json.admin session.account.admin
json.rights rights
json.account do
  json.id session.account.id.to_s
  json.username session.account.username
  json.email session.account.email
end
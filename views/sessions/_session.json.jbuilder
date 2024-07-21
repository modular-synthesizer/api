json.created_at session.created_at.iso8601(0)
json.account_id session.account.id.to_s
json.(session, :token, :duration)
json.(session.account, :username, :email, :admin)
json.rights rights
# frozen_string_literal: true

def create_token(account)
  token = Modusynth::Services::Tokens.instance.create(
    username: account.username,
    password: account.password
  )
  token[:jwt_token]
end

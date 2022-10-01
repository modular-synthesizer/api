def create_payload verb, session, parameters = {}
  parameters = parameters.merge({auth_token: session.token})
  ['post', 'put'].include?(verb) ? parameters.to_json : parameters
end
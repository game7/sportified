def login_as(user)
  Tenant.current = Tenant.find(user.tenant_id)
  user_session = Passwordless::Session.create(
    authenticatable: user,
    user_agent: 'TestAgent',
    remote_addr: 'unknown'
  )
  get Passwordless::Engine.routes.url_helpers.token_sign_in_path(user_session.token)
end
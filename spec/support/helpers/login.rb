def login_as(user)
  Tenant.current = Tenant.find(user.tenant_id)
  session = Passwordless::Session.create!(authenticatable: user, user_agent: 'TestAgent', remote_addr: 'unknown')
  get Passwordless::Engine.routes.url_helpers.token_sign_in_path(session.token)
  follow_redirect!  
end

def logout
  delete Passwordless::Engine.routes.url_helpers.sign_out_path
  follow_redirect!
end

# module PasswordlessSupport
#   module TestCase
#     def passwordless_sign_out
#       delete Passwordless::Engine.routes.url_helpers.sign_out_path
#       follow_redirect!
#     end

#     def passwordless_sign_in(resource)
#       session = Passwordless::Session.create!(authenticatable: resource, user_agent: 'TestUnit', remote_addr: 'unknown')
#       get Passwordless::Engine.routes.url_helpers.token_sign_in_path(session.token)
#       follow_redirect!
#     end
#   end

#   module SystemTestCase
#     def passwordless_sign_in(resource)
#       session = Passwordless::Session.create!(authenticatable: resource, user_agent: 'TestUnit', remote_addr: 'unknown')
#       visit Passwordless::Engine.routes.url_helpers.token_sign_in_path(session.token)
#     end
#   end
# end

# class ActiveSupport::TestCase
#   include ::PasswordlessSupport::TestCase
# end
# class ActionDispatch::SystemTestCase
#   include ::PasswordlessSupport::SystemTestCase
# end
module Passwordless
    SessionsController.class_eval do
        # post '/sign_in'
        #   Creates a new Session record then sends the magic link
        #   renders sessions/create.html.erb.
        # @see Mailer#magic_link Mailer#magic_link
        def create
            @resource = find_authenticatable
            session = build_passwordless_session(@resource)
      
            if session.save
              if Passwordless.after_session_save.arity == 2
                Passwordless.after_session_save.call(session, request)
              else
                Passwordless.after_session_save.call(session)
              end
              redirect_to send(Passwordless.mounted_as).token_sign_in_url(session.token) if Rails.env.development?
            else
              render
            end
        end
    end
end    
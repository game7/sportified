class AuthenticationsController < ApplicationController
  
  def index
    @authentications = current_user.authentications if current_user
  end
  
  def create
    omniauth = request.env["omniauth.auth"]
    user = User.find_by_auth_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if user
      # Just sign in existing user with omniauth
      # The user has already used this external account
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, user)
    elsif current_user
      # Add external account to currently signed-in user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "Authentication successful."
      redirect_to authentications_url
    else
      # user is not signed in
      # Lets check for existing user with matching email address
      email = omniauth['user_info']['email']
      user = User.with_email(email).first if email
      if user
        # account exists with same email address
        # Add external account to the user
        user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
        flash[:notice] = "Authentication successful."
        sign_in_and_redirect(:user, user)
      else
        # no matching user account - let's create one now
        user = User.new
        user.password = Devise.friendly_token[0,20]
        user.apply_omniauth(omniauth)
        if user.save
          flash[:notice] = "Signed in successfully."
          sign_in_and_redirect(:user, user)
        else
          flash[:notice] = user.errors
          session[:omniauth] = omniauth.except('extra')
          redirect_to new_user_registration_url        
        end
      end
    end
  end
  
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end

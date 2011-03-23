class Admin::AdminController < ApplicationController
  load_and_authorize_resource
  layout 'admin'

  def current_ability
    @current_ability ||= Ability.new(current_user, Site.current)
  end  

end

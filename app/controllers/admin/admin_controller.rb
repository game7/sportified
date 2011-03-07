class Admin::AdminController < ApplicationController
  load_and_authorize_resource

  def current_ability
    @current_ability ||= Ability.new(current_user, Site.current)
  end  

end

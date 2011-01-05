class HomeController < ApplicationController
  
  def index
    @users = User.all
    @divisions = Division.find(:all)
  end

end

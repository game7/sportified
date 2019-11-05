class Admin::ConsoleController < ApplicationController
  before_action :verify_admin
  layout 'console'

  def index
  end

end

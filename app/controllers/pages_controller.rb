# == Schema Information
#
# Table name: pages
#
#  id                  :integer          not null, primary key
#  tenant_id           :integer
#  title               :string
#  slug                :string
#  url_path            :string
#  meta_keywords       :text
#  meta_description    :text
#  link_url            :string
#  show_in_menu        :boolean
#  title_in_menu       :string
#  skip_to_first_child :boolean
#  draft               :boolean
#  ancestry            :string
#  ancestry_depth      :integer
#  position            :integer
#  mongo_id            :string
#  created_at          :datetime
#  updated_at          :datetime
#
require 'rest_client'

class PagesController < ApplicationController
  before_action :verify_admin, :except => [:show]
  before_action :verify_stripe_connect, :only => [:show], :if => :stripe_request?
  before_action :find_page, :only => [:edit, :update, :destroy]
  before_action :load_parent_options, :only => [:new, :edit]
  before_action :mark_return_point, :only => [:new, :edit]

  def index
    @pages = Page.arrange(:order => :position)
  end

  def show
    current_user
    redirect_to first_live_child.url if @page.skip_to_first_child and (first_live_child = @page.children.live.order(:position).first).present?
  end

  def edit

  end

  def update
    @page.update_attributes(page_params)
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      return_to_last_point(:notice => 'Page was successfully created.')
    else
      render :action => "new"
    end
  end

  def destroy
    @page.delete
    flash[:notice] = "Page '#{@page.title}' has been deleted"
  end

  def position
    params['page'].each_with_index do |id, i|
      page = Page.find(id);
      if page
        page.position = i
        page.save
      end
    end
    render :nothing => true
  end

  private

  def page_params
    params.required(:page).permit(:title, :parent_id, :show_in_menu, :title_in_menu,
                                  :link_url, :skip_to_first_child,
                                  :meta_keywords, :meta_description)
  end

  def load_objects
    find_page
  end

  def find_page
    @page = params[:id] ? Page.find(params[:id]) : find_page_by_path
  end

  def find_page_by_path
    page = Page.find_by_path(params[:path])
    page ||= Page.new(:title => 'Welcome') unless params[:path]
    page
  end

  def set_breadcrumbs
    (@page.ancestors + [@page]).each do |parent|
      add_breadcrumb parent.title_in_menu.presence || parent.title, get_page_url(parent)
    end unless @page.root?
  end

  def set_area_navigation
    set_child_page_navigation if [:show, :edit].include? params[:action].to_sym
  end

  def set_child_page_navigation
    has_children = false
    @page.children.in_menu.order(:position).each do |child|
      has_children = true
      add_area_menu_item child.title_in_menu.presence || child.title, get_page_url(child)
    end unless @page.new_record?
    unless @page.root? or has_children
      @page.siblings.in_menu.order(:position).each do |sibling|
        add_area_menu_item sibling.title_in_menu.presence || sibling.title, get_page_url(sibling)
      end
    end
  end

  def load_parent_options
    @parent_options = Page.arrange_as_array(:order => :position).collect do |page|
      [ page.name_for_selects, page.id]
    end
  end

  def stripe_request?
    params[:code] and params[:scope]
  end

  def verify_stripe_connect
    payload = {
      client_secret: ENV['STRIPE_SECRET_KEY'],
      code: params[:code],
      grant_type: 'authorization_code'
    }
    begin
      response = RestClient.post 'https://connect.stripe.com/oauth/token', payload
    rescue => e
      raise e.response
    end
    parsed = ActiveSupport::JSON.decode(response)
    Tenant.current.update_attributes(
      stripe_account_id: parsed["stripe_user_id"],
      stripe_access_token: parsed["access_token"],
      stripe_public_api_key: parsed["stripe_publishable_key"]
    )
    flash[:success] = "Sweet!  Your Stripe account is now connected."
    redirect_to '/registrar/items'
  end

end

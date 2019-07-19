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
#  created_at          :datetime
#  updated_at          :datetime
#  content             :text
#
# Indexes
#
#  index_pages_on_ancestry   (ancestry)
#  index_pages_on_tenant_id  (tenant_id)
#

class PagesController < ApplicationController
  before_action :verify_admin, :except => [:show]
  before_action :verify_stripe_connect, :only => [:show], :if => :stripe_request?
  before_action :find_page, :only => [:edit, :update, :destroy]
  before_action :load_parent_options, :only => [:new, :edit]
  before_action :mark_return_point, :only => [:new, :edit]
  layout 'admin', only: :index

  def index
    @pages = Page.arrange_as_array(order: :position)
  end

  def show
    redirect_to @page.link_url if @page.link_url.present?
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
    @page.position = @page.parent.children.count
    if @page.save
      return_to_last_point(success: 'Page was successfully created.')
    else
      render action: :new
    end
  end

  def destroy
    @page.delete
    flash[:notice] = "Page '#{@page.title}' has been deleted"
    @pages = Page.arrange_as_array(order: :position)
  end

  def move_up
    page = Page.find(params[:id])
    siblings = page.siblings.order(:position).pluck(:id)
    current_position = siblings.index(page.id)
    puts current_position
    puts siblings.to_json
    if (current_position > 0)
      siblings = siblings.insert(current_position - 1, siblings.delete_at(current_position))
    end
    puts siblings.to_json
    siblings.each_with_index{|id, i| Page.update(id, position: i)}
    redirect_to pages_path, notice: 'Page has been moved up'
    # @pages = Page.arrange_as_array(order: :position)
  end

  def move_down
    page = Page.find(params[:id])
    siblings = page.siblings.order(:position).pluck(:id)
    current_position = siblings.index(page.id)
    if (current_position < siblings.length - 1)
      siblings = siblings.insert(current_position, siblings.delete_at(current_position - 1))
    end
    siblings.each_with_index{|id, i| Page.update(id, position: i)}

    redirect_to pages_path, notice: 'Page has been moved down'
    # @pages = Page.arrange_as_array(order: :position)
  end


  private

    def page_params
      params.required(:page).permit(:title, :parent_id, :show_in_menu, :title_in_menu,
                                    :link_url, :skip_to_first_child,
                                    :meta_keywords, :meta_description,
                                    :content)
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
      @parent_options = Page.options
    end

    def stripe_request?
      params[:code] and params[:scope]
    end

    def verify_stripe_connect
      require 'httparty'
      path = 'https://connect.stripe.com/oauth/token'
      options = {
        body: {
          client_secret: Tenant.current.stripe_private_key.presence || ENV['STRIPE_SECRET_KEY'],
          code: params[:code],
          grant_type: 'authorization_code'
        }
      }
      begin
        puts options
        response = HTTParty.post path, options
        puts response
      rescue => e
        raise e
      end
      Tenant.current.update_attributes(
        stripe_account_id: response['stripe_user_id'],
        stripe_access_token: response['access_token'],
        stripe_public_api_key: response['stripe_publishable_key']
      )
      flash[:success] = 'Sweet!  Your Stripe account is now connected.'
      redirect_to '/registrar/items'
    end

end

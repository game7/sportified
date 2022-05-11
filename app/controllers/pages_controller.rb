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
  before_action :stripe_connect_complete, :only => [:show], :if => :stripe_connect_complete?
  before_action :stripe_connect_error, :only => [:show], :if => :stripe_connect_error?
  before_action :find_page, :only => [:edit, :update, :destroy]
  before_action :load_parent_options, :only => [:new, :edit]
  before_action :mark_return_point, :only => [:new, :edit]
  layout 'admin', only: [:index, :new, :create]

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
    @page.position = @page.parent&.children&.count
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
    if (current_position > 0)
      siblings = siblings.insert(current_position - 1, siblings.delete_at(current_position))
    end
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
      set_child_page_navigation if %w{show edit}.include? params[:action]
    end

    def set_child_page_navigation
      children = @page.children.in_menu.order(:position).entries
      if (children.any?)
        add_area_menu_item @page.title_in_menu.presence || @page.title, nil, :header
        children.each do |child|
          add_area_menu_item child.title_in_menu.presence || child.title, get_page_url(child)
        end
      end
      unless @page.root? or children.any?
        add_area_menu_item @page.parent.title, nil, :header
        @page.siblings.in_menu.order(:position).each do |sibling|
          add_area_menu_item sibling.title_in_menu.presence || sibling.title, get_page_url(sibling)
        end
      end
    end

    def load_parent_options
      @parent_options = Page.options
    end

    def stripe_connect_complete?
      params[:state] && params[:code]
    end

    def stripe_connect_error?
      params[:state] && params[:error]
    end

    def stripe_connect_error
      connect = StripeConnect.unscoped.pending.find_by_token(params[:state])
      connect.update_attributes(status: params[:error])
      redirect_to connect.referrer, flash: { error: params[:error_description] }
    end

    def stripe_connect_complete
      connect = StripeConnect.unscoped.pending.find_by_token(params[:state])
      Stripe::api_key = connect.tenant.stripe_private_key.presence || ENV['STRIPE_SECRET_KEY']
      token = Stripe::OAuth.token({
        grant_type: 'authorization_code',
        code: params[:code],
      })
      connect.tenant.update_attributes(
        stripe_account_id: token.stripe_user_id,
        stripe_access_token: token.access_token,
        stripe_public_api_key: token.stripe_publishable_key
      )
      connect.update_attributes({
        status: :completed,
        result: token
      })
      redirect_to connect.referrer, flash: { success: 'Stripe has been connected!' }
    end

end

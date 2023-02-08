class Admin::PostsController < Admin::AdminController

  before_action :find_post, :only => [:edit, :update, :destroy]
  before_action :mark_return_point, :only => [:new, :edit]
  before_action :add_posts_breadcrumb

  def index
    @posts = Post.all.newest_first.includes(:tags).page(params[:page])
    @tags = Post.tag_counts
  end

  def edit

  end

  def update
    if @post.update(post_params)
      return_to_last_point(:notice => 'Post has been updated')
    else
      render :action => "edit"
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      return_to_last_point(:notice => 'Post has been successfully created.')
    else
      render :action => "new"
    end
  end

  def destroy
    @post.delete
    flash[:notice] = "Post has been deleted"
    return_to_last_point :success => 'Post has been deleted.'
  end

  private

  def post_params
    params.required(:post).permit(:title, :summary, :body, :link_url, :tag_list, :image, :remote_image_url, :image_cache)
  end

  def find_post
    @post = Post.find(params[:id])
  end

  def add_posts_breadcrumb
    add_breadcrumb 'Posts', admin_posts_url
  end

end

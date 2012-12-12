class Admin::PostsController < Admin::AdminController
  
  before_filter :find_post, :only => [:edit, :update, :destroy]
  before_filter :mark_return_point, :only => [:new, :edit]
  
  def index
    @posts = Post.all.newest_first.page(params[:page])
    @tags = Post.tags
  end

  def edit
    
  end

  def update
    if @post.update_attributes(params[:post])
      return_to_last_point(:notice => 'Post has been updated')
    else
      render :action => "edit"
    end    
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(params[:post])
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

  def find_post
    @post = Post.find(params[:id])
  end
  
end

class Next::Admin::PostsController < Next::Admin::BaseController
  before_action :set_post, only: %i[show edit update]
  before_action :mark_return_point, only: %i[new edit]

  def index
    inertia props: {
      posts: Post.order(updated_at: :desc)
    }
  end

  def show
    inertia props: {
      post: @post
    }
  end

  def new
    inertia props: {
      post: Post.new
    }
  end

  def create
    if (@post = Post.new(post_params)).save
      return_to_last_point success: 'Post was successfully created.'
    else
      redirect_to new_next_admin_post_path, inertia: { errors: @post.errors },
                                            error: 'Post could not be created.'
    end
  end

  def edit
    inertia props: {
      post: @post
    }
  end

  def update
    if @post.update(post_params)
      return_to_last_point success: 'Post was successfully updated.'
    else
      redirect_to edit_next_admin_post_path(@post), inertia: { errors: @post.errors },
                                                    error: 'Post could not be updated.'
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :summary, :body)
  end
end

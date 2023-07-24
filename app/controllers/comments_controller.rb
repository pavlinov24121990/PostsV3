class CommentsController < AdminController
  before_action :authenticate_user!
  before_action :post_find
  before_action :comment_find, except: %i[create]

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to posts_path
      flash[:success] = "Comment go approved to admin!"
    else
      render 'posts/show', status: :unprocessable_entity
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    if @comment.destroy
      redirect_to edit_admin_post_path(@post)
      flash[:success] = "Comment deleted!"
    else
      flash[:alert] = "Errors!"
      redirect_to edit_admin_post_path(@post)
    end
  end

  def edit
  end

  def update
    @comment = @post.comments.find(params[:id])
    if @comment.update(comment_params)
      redirect_to edit_admin_post_path(@post)
      flash[:success] = "Comment update!"
    else
      flash[:alert] = "Errors!"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def post_find
    @post = Post.find(params[:post_id])
  end

  def comment_find
    @comment = @post.comments.find(params[:id])
  end
end

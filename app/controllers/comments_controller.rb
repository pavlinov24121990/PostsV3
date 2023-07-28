# frozen_string_literal: true

class CommentsController < AdminController
  before_action :authenticate_user!
  before_action :post_find
  before_action :comment_find, except: %i[create]

  include Pagy::Backend

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to post_path(@post)
      flash[:success] = 'Comment go approved to admin!'
    else
      @pagy, @comments = pagy(@post.comments.approved, items: 2)
      render 'posts/show', status: :unprocessable_entity
    end
  end
      # ПРИМЕР!!!!!
     # flash[:success] = 'Comment go approved to admin!'
      # turbo_stream.append(:comments, @comment, partial: "comments/comments", locals: { comment: @comment })
      #  turbo_stream.after(:append, :formComment) do
      #   page[:f][:body].reset
      # end
      # respond_to do |format|
      #   format.turbo_stream do
      #     render turbo_stream: turbo_stream.append(:comments, @comment, partial: "comment", locals: { comment: @comment })
      #   end
      # end

  def destroy
    @comment = @post.comments.find(params[:id])
    if @comment.destroy
      redirect_to edit_admin_post_path(@post)
      flash[:success] = 'Comment deleted!'
    else
      flash[:alert] = 'Errors!'
      redirect_to edit_admin_post_path(@post)
    end
  end

  def update
    @comment = @post.comments.find(params[:id])
    if @comment.update(comment_params)
      redirect_to edit_admin_post_path(@post)
      flash[:success] = 'Comment update!'
    else
      flash[:alert] = 'Errors!'
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

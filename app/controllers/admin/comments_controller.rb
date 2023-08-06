module Admin
  class CommentsController < AdminController
    
    before_action :post_find
    before_action :comment_find, except: %i[create]

    include Pagy::Backend

    def update
      @post = Post.find(params[:post_id])
      @comment = @post.comments.find(params[:id])
      if @comment.update(approved: true)
        flash[:success] = 'Comment approved!'
        redirect_to edit_admin_post_path(@post)
      else
        redirect_to edit_admin_post_path(@post), status: :unprocessable_entity
      end
    end
  end

 def destroy
    @comment = @post.comments.find(params[:id])
    if @comment.destroy
      respond_to do |format|
        format.turbo_stream do
          flash[:success] = 'Comment Deleted!'
          @pagy, @comments = pagy(@post.comments, items: 2)
          render turbo_stream: turbo_stream.update(:comments_paginate, partial: "admin/posts/comments", locals: { comments: @comments, pagy: @pagy })
        end
      end
    else
      redirect_to edit_admin_post_path(@post)
      flash[:success] = 'Error'
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
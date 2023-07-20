module Admin
  class CommentsController < ApplicationController
    def update
      @post = Post.find(params[:post_id])
      @comment = @post.comments.find(params[:id])
      @comment.approved = true
      if @comment.save
        flash[:success] = "Comment approved!"
        redirect_to admin_post_path(@post)
      else
        flash[:alert] = "Errors!"
        redirect_to admin_post_path(@post)
      end
    end
  end
end

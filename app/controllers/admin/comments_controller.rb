module Admin
  class CommentsController < AdminController
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
end

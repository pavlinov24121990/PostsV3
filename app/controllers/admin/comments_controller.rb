module Admin
  class CommentsController < AdminController
    
    def update
      @post = Post.find(params[:post_id])
      @comment = @post.comments.find(params[:id])
      if @comment.update(approved: true)
        flash[:success] = "Comment approved!"
        redirect_to edit_admin_post_path(@post)
      else
        flash[:alert] = "Errors!"
        redirect_to edit_admin_post_path(@post)
      end
    end
  end
end

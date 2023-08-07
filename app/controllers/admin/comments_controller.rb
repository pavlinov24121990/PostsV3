module Admin
  
  class CommentsController < AdminController
    
    before_action :post_find
    before_action :comment_find, except: %i[create]

    include Pagy::Backend

    def update
      if @comment.update(approved: true)
        respond_to do |format|
          format.turbo_stream do
            flash[:success] = 'Comment approved!'
            @pagy, @comments = pagy(@post.comments, request_path: edit_admin_post_path(@post), items: 2)
            render turbo_stream: [turbo_stream.update(:comments, partial: "admin/comments/comments", locals: { comment: @comments, pagy: @pagy }), 
                                  turbo_stream.update(:flash, partial: "shared/flash")]
          end
        end
      else
        redirect_to edit_admin_post_path(@post), status: :unprocessable_entity
      end
    end

  def mark_destroy
    if @comment.update(scheduled_for_deletion_at: true)
        respond_to do |format|
          format.turbo_stream do
            flash[:success] = 'Comment mark or deleted!'
            @pagy, @comments = pagy(@post.comments, request_path: edit_admin_post_path(@post), items: 2)
            render turbo_stream: [turbo_stream.update(:comments, partial: "admin/comments/comments", locals: { comment: @comments, pagy: @pagy }), 
                                  turbo_stream.update(:flash, partial: "shared/flash")]
          end
        end
      else
        redirect_to edit_admin_post_path(@post), status: :unprocessable_entity
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

end
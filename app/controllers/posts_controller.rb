class PostsController < ApplicationController
  
  include Pagy::Backend

  def index
    @pagy, @posts = pagy(Post.order(created_at: :desc), items: 2)
  end
  
  def show
    @post = Post.find(params[:id])
    @pagy, @comments = pagy(@post.comments.approved, items: 2)
    @comment = @post.comments.new
  end
end

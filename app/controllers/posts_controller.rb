class PostsController < ApplicationController

  def index
    @posts = Post.order(created_at: :desc)
  end
  
  def show
    @post = Post.find(params[:id])
    @comment = @post.comments.new
  end
end

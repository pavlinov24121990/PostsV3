class PostsController < ApplicationController

  def index
    @posts = Post.order(created_at: :desc).page(params[:page])
  end
  
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.approved.page(params[:page])
    @comment = @post.comments.new
  end
end

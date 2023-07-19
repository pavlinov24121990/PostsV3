class PostsController < ApplicationController

  def index
    @post = Post.order(created_at: :desc)
  end
  
  def show
    @post = Post.find(params[:id])
  end
end
